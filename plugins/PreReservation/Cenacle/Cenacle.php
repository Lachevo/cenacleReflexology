<?php

require_once(dirname(__FILE__) . '/CenacleValidation.php');

/**
 * Cenacle Reflexology – Pre-Reservation Validation Plugin
 *
 * Enforces business rules:
 * 1. Resource Compatibility:
 *    - Full Body and Back Massages MUST use the Massage Bed (Resource 7 / "Bed").
 *    - Foot, Hand, and Head & Shoulder treatments MUST use Chairs 1–6.
 * 2. Operating Hours & Cutoff:
 *    - Last reservation start time is 1:30 AM (closing is 2:30 AM).
 * 3. Double-Booking Prevention:
 *    - Enforced by decorating the core validation pipeline.
 */
class Cenacle implements IPreReservationFactory
{
    private PreReservationFactory $factoryToDecorate;

    public function __construct(PreReservationFactory $factoryToDecorate)
    {
        $this->factoryToDecorate = $factoryToDecorate;
    }

    public function CreatePreAddService(UserSession $userSession)
    {
        $base = $this->factoryToDecorate->CreatePreAddService($userSession);
        return new CenacleValidation($base);
    }

    public function CreatePreUpdateService(UserSession $userSession)
    {
        $base = $this->factoryToDecorate->CreatePreUpdateService($userSession);
        return new CenacleValidation($base);
    }

    public function CreatePreDeleteService(UserSession $userSession)
    {
        return $this->factoryToDecorate->CreatePreDeleteService($userSession);
    }

    public function CreatePreApprovalService(UserSession $userSession)
    {
        return $this->factoryToDecorate->CreatePreApprovalService($userSession);
    }

    public function CreatePreCheckinService(UserSession $userSession)
    {
        return $this->factoryToDecorate->CreatePreCheckinService($userSession);
    }

    public function CreatePreCheckoutService(UserSession $userSession)
    {
        return $this->factoryToDecorate->CreatePreCheckoutService($userSession);
    }
}

