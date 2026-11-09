<?php

class CenacleValidation implements IReservationValidationService
{
    private IReservationValidationService $serviceToDecorate;

    public function __construct(IReservationValidationService $serviceToDecorate)
    {
        $this->serviceToDecorate = $serviceToDecorate;
    }

    public function Validate($series, $retryParameters = null)
    {
        // First run core validations (including double-booking / conflict detection)
        $result = $this->serviceToDecorate->Validate($series, $retryParameters);
        if (!$result->CanBeSaved()) {
            return $result;
        }

        // 1. Validate Resource compatibility with Treatment type
        $resourceError = $this->ValidateResourceCompatibility($series);
        if ($resourceError !== null) {
            return new ReservationValidationResult(false, [$resourceError]);
        }

        // 2. Validate Reservation Cutoff & Operating Hours
        $timeError = $this->ValidateOperatingHours($series);
        if ($timeError !== null) {
            return new ReservationValidationResult(false, [$timeError]);
        }

        return new ReservationValidationResult();
    }

    /**
     * Checks if the selected treatment requires a Bed or a Chair,
     * and ensures the correct resource is chosen.
     */
    private function ValidateResourceCompatibility($series): ?string
    {
        $treatment = strtolower($series->GetAttributeValue(1) ?? $series->Title() ?? '');
        $description = strtolower($series->Description() ?? '');
        $combinedText = $treatment . ' ' . $description;

        $isBedService = str_contains($combinedText, 'full body') || str_contains($combinedText, 'back massage');
        $isChairService = str_contains($combinedText, 'foot') ||
                          str_contains($combinedText, 'head') ||
                          str_contains($combinedText, 'shoulder') ||
                          str_contains($combinedText, 'hand');

        $allResources = array_filter($series->AllResources() ?? []);
        if (empty($allResources)) {
            $primary = $series->Resource();
            if ($primary) {
                $allResources = [$primary];
            }
        }

        foreach ($allResources as $res) {
            if (!$res) continue;
            $name = strtolower($res->GetName() ?? '');
            $isBed = str_contains($name, 'bed') || ($res->GetId() == 7);

            if ($isBedService && !$isBed) {
                return 'Full Body Massage and Back Massage require a treatment bed. Please select the Massage Bed.';
            }

            if ($isChairService && $isBed) {
                return 'Foot, Hand, and Head & Shoulder reflexology treatments are conducted on Chairs 1–6. The bed is reserved for Full Body and Back masssages.';
            }
        }

        return null;
    }

    /**
     * Validates that the reservation begins during operating hours
     * and no later than 1:30 AM (last reservation time).
     */
    private function ValidateOperatingHours($series): ?string
    {
        try {
            $instances = $series->Instances() ?? [];
            foreach ($instances as $instance) {
                if (!$instance) continue;
                /** @var Date $startDate */
                $startDate = $instance->StartDate();
                if (!$startDate) {
                    continue;
                }

                // Convert to Addis Ababa local time
                $local = $startDate->ToTimezone('Africa/Addis_Ababa');
                $hour = (int)$local->Format('H');
                $min = (int)$local->Format('i');
                $dayOfWeek = (int)$local->Format('w'); // 0 = Sunday, 1 = Monday ... 6 = Saturday

                $minutesSinceMidnight = ($hour * 60) + $min;

                // Cutoff check: between 01:31 AM and 02:30 AM is prohibited (last reservation at 1:30 AM)
                if ($minutesSinceMidnight > 90 && $minutesSinceMidnight <= 150) {
                    return 'Reservations can only be placed up until 1:30 AM. Cenacle closes at 2:30 AM.';
                }

                // Closed hours check: between 02:30 AM (150m) and opening time
                // Sunday opens at 16:00 (960m), Mon–Sat opens at 14:30 (870m)
                $openMinutes = ($dayOfWeek === 0) ? 960 : 870;

                if ($minutesSinceMidnight > 150 && $minutesSinceMidnight < $openMinutes) {
                    $openTimeStr = ($dayOfWeek === 0) ? '4:00 PM (Sunday)' : '2:30 PM (Mon–Sat)';
                    return "Cenacle is closed at this time. Opening time is $openTimeStr.";
                }
            }
        } catch (\Throwable $t) {
            error_log('ValidateOperatingHours error: ' . $t->getMessage());
        }

        return null;
    }
}

