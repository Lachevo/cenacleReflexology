<?php

/**
 * Cenacle Reflexology – Styling Plugin
 *
 * Applies:
 *  - Cenacle brand CSS (colours, fonts, minimal look)
 *  - Per-service colour coding on the schedule grid
 *
 * Service → CSS class mapping (tied to reservation title keywords):
 *   "Foot Reflexology"        → cenacle-foot         (blue  #4A90D9)
 *   "Full Body"               → cenacle-fullbody      (purple #8B5CF6)
 *   "Back Massage"            → cenacle-back          (mauve  #B07DB0)
 *   "Head" / "Shoulder"       → cenacle-headshoulder  (sage   #5FAD8E)
 *   "Hand Reflexology"        → cenacle-hand          (coral  #E8865A)
 */
class CenacleStyling implements IStylingFactory
{
    private StylingFactory $factoryToDecorate;

    /** Maps keywords (lowercase) in a reservation title to a CSS class */
    private const SERVICE_COLOUR_MAP = [
        'foot'        => 'cenacle-foot',
        'full body'   => 'cenacle-fullbody',
        'back massage'=> 'cenacle-back',
        'head'        => 'cenacle-headshoulder',
        'shoulder'    => 'cenacle-headshoulder',
        'hand'        => 'cenacle-hand',
    ];

    public function __construct(StylingFactory $factoryToDecorate)
    {
        $this->factoryToDecorate = $factoryToDecorate;
    }

    /**
     * Return path to the Cenacle custom CSS file so the application
     * serves it via styling-plugin.php.
     */
    public function AdditionalCSS(UserSession $userSession): string
    {
        return realpath(__DIR__ . DIRECTORY_SEPARATOR . 'Cenacle.css');
    }

    /**
     * Add a service-colour CSS class to every reservation block so the
     * schedule grid shows each treatment category in its own colour.
     *
     * @param IReservedItemView $item
     * @return string[]
     */
    public function GetReservationAdditonalCSSClasses(IReservedItemView $item): array
    {
        $classes = $this->factoryToDecorate->GetReservationAdditonalCSSClasses($item) ?? [];

        $title = strtolower($item->GetTitle() . ' ' . $item->GetLabel());

        // Check longest-match keys first to avoid "foot" matching before "full body"
        $matched = false;
        foreach (self::SERVICE_COLOUR_MAP as $keyword => $cssClass) {
            if (str_contains($title, $keyword)) {
                if (!in_array($cssClass, $classes, true)) {
                    $classes[] = $cssClass;
                }
                $matched = true;
                break;
            }
        }

        // If no title match, fall back to the resource description / notes
        // (useful when reservations have no descriptive title)
        if (!$matched) {
            $description = strtolower($item->GetDescription() ?? '');
            foreach (self::SERVICE_COLOUR_MAP as $keyword => $cssClass) {
                if (str_contains($description, $keyword)) {
                    if (!in_array($cssClass, $classes, true)) {
                        $classes[] = $cssClass;
                    }
                    break;
                }
            }
        }

        return $classes;
    }
}

