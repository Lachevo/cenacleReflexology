<!-- tpl/Schedule/schedule.tpl -->
{* All of the slot display formatting *}

{function name=displayPastTime}
    <td ref="{$SlotRef}" class="pasttime slot" data-href="{$Href}"
        data-start="{$Slot->BeginDate()->Format('Y-m-d H:i:s')|escape:url}"
        data-end="{$Slot->EndDate()->Format('Y-m-d H:i:s')|escape:url}" data-min="{$Slot->BeginDate()->Timestamp()}"
        data-max="{$Slot->EndDate()->Timestamp()}" data-resourceId="{$ResourceId}">&nbsp;
    </td>
{/function}

{function name=displayReservable}
    <td class="reservable clickres slot" ref="{$SlotRef}" data-href="{$Href}"
        data-start="{$Slot->BeginDate()->Format('Y-m-d H:i:s')|escape:url}"
        data-end="{$Slot->EndDate()->Format('Y-m-d H:i:s')|escape:url}" data-min="{$Slot->BeginDate()->Timestamp()}"
        data-max="{$Slot->EndDate()->Timestamp()}" data-resourceId="{$ResourceId}">&nbsp;
    </td>
{/function}

{function name=displayRestricted}
    <td ref="{$SlotRef}" class="restricted slot" data-href="{$Href}"
        data-start="{$Slot->BeginDate()->Format('Y-m-d H:i:s')|escape:url}"
        data-end="{$Slot->EndDate()->Format('Y-m-d H:i:s')|escape:url}" data-min="{$Slot->BeginDate()->Timestamp()}"
        data-max="{$Slot->EndDate()->Timestamp()}" data-resourceId="{$ResourceId}">&nbsp;
    </td>
{/function}

{function name=displayUnreservable}
    <td ref="{$SlotRef}" class="unreservable slot" data-href="{$Href}"
        data-start="{$Slot->BeginDate()->Format('Y-m-d H:i:s')|escape:url}"
        data-end="{$Slot->EndDate()->Format('Y-m-d H:i:s')|escape:url}" data-min="{$Slot->BeginDate()->Timestamp()}"
        data-max="{$Slot->EndDate()->Timestamp()}" data-resourceId="{$ResourceId}">&nbsp;
    </td>
{/function}

{function name=displaySlot}
    {call name=$DisplaySlotFactory->GetFunction($Slot, $AccessAllowed) Slot=$Slot Href=$Href SlotRef=$SlotRef ResourceId=$ResourceId}
{/function}

{* End slot display formatting *}

{block name="header"}
    {include file='globalheader.tpl' Select2=true DatePicker=true cssFiles='assets/vendor/jqtree/1.8.11/css/jqtree.css,css/schedule.css' printCssFiles='css/schedule.print.css'}
{/block}

<div id="page-schedule">
    {assign var=startTime value=microtime(true)}

    {if isset($ShowResourceWarning) && $ShowResourceWarning}
        <div class="alert alert-warning no-resource-warning"><i class="bi bi-exclamation-triangle-fill"></i>
            {translate key=NoResources}
            <a class="alert-link" href="admin/manage_resources.php">{translate key=AddResource}</a>
    </div> {/if}

    {if $CanViewAdmin}
        <div id="slow-schedule-warning" class="alert alert-warning d-flex align-items-center d-none" role="alert">
            <div>
                <p>We noticed this page is taking a long time to load. To speed ths page up, try
                    reducing the number of <a class="alert-link" href="admin/manage_resources.php">resources</a> on this
                    schedule or
                    reducing the number of <a class="alert-link" href="admin/manage_schedules.php">days</a> being shown.
                </p>
                <p class="mb-0">
                    This page is taking <span id="warning-time"></span> seconds to load
                    <span id="warning-resources"></span> resources for <span id="warning-days"></span> days.
                    <button type="button" class="close close-forever btn btn-link alert-link"
                        aria-label="Do not show again">
                        <span aria-hidden="true">Do not show again</span>
                    </button>
                </p>
            </div>
            <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    {/if}

    {if $IsAccessible}
        {block name="schedule_control"}
            <div class="row">
                {assign var=titleWidth value="col-sm-12 col-12"}
                {if !isset($HideSchedule) || !$HideSchedule}
                    {assign var=titleWidth value="col-sm-6 col-12"}
                    <div id="schedule-actions" class="col-sm-3 col-12">
                        {block name="actions"}
                            <div class="d-flex align-items-center mb-2">
                                <div class="me-4 d-flex align-items-center gap-2">
                                    <a href="#" id="print_schedule" class="link-primary me-1" title="{translate key=Print}">
                                        <i class="bi bi-printer schedule_icon"></i>
                                    </a>
                                    {if $LoggedIn}
                                        <a href="#" id="make_default" class="link-primary" title="{translate key='MakeDefaultSchedule'}">
                                            <i class="bi bi-star-fill schedule_icon"></i>
                                        </a>
                                    {/if}
                                </div>
                                <a href="#"
                                    class="schedule-style me-2 d-inline-flex align-items-center{if $ScheduleStyle == ScheduleStyle::Standard->value} active{/if}"
                                    id="schedule_standard" schedule-display="{ScheduleStyle::Standard->value}"
                                    title="{if $IsMobile && !$IsTablet}{translate key='CondensedWeekScheduleDisplay'}{else}{translate key='StandardScheduleDisplay'}{/if}">
                                    <img class="schedule_icon shadow-sm" src="{if $IsMobile && !$IsTablet}img/table-week.png{else}img/table.png{/if}"
                                        alt="{if $IsMobile && !$IsTablet}{translate key='CondensedWeekScheduleDisplay'}{else}{translate key='StandardScheduleDisplay'}{/if}" />
                                </a>
                                <a href="#"
                                    class="schedule-style me-2 d-inline-flex align-items-center{if $ScheduleStyle == ScheduleStyle::Tall->value} active{/if}"
                                    id="schedule_tall" schedule-display="{ScheduleStyle::Tall->value}"
                                    title="{translate key='TallScheduleDisplay'}">
                                    <img class="schedule_icon shadow-sm" src="img/table-tall.png"
                                        alt="{translate key='TallScheduleDisplay'}" />
                                </a>
                                {if !$IsMobile || $IsTablet}
                                <a href="#"
                                    class="schedule-style d-inline-flex me-2 align-items-center{if $ScheduleStyle == ScheduleStyle::Wide->value} active{/if}"
                                    id="schedule_wide" schedule-display="{ScheduleStyle::Wide->value}"
                                    title="{translate key='WideScheduleDisplay'}">
                                    <img class="schedule_icon shadow-sm" src="img/table-wide.png"
                                        alt="{translate key='WideScheduleDisplay'}" />
                                </a>
                                <a href="#"
                                    class="schedule-style d-inline-flex align-items-center{if $ScheduleStyle == ScheduleStyle::CondensedWeek->value} active{/if}"
                                    id="schedule_week" schedule-display="{ScheduleStyle::CondensedWeek->value}"
                                    title="{translate key='CondensedWeekScheduleDisplay'}">
                                    <img class="schedule_icon shadow-sm" src="img/table-week.png"
                                        alt="{translate key='CondensedWeekScheduleDisplay'}" />
                                </a>
                                {/if}
                            </div>
                            {if isset($SubscriptionUrl) && $SubscriptionUrl != null && $ShowSubscription && $LoggedIn}
                                {assign var="atomUrl" value=$SubscriptionUrl->GetAtomUrl()}
                                {assign var="icalUrl" value=$SubscriptionUrl->GetWebcalUrl()}
                                <div class="d-flex align-items-center"><i class="bi bi-rss-fill link-primary me-1"></i>
                                    <a class="link-primary me-1" target="_blank" href="{$atomUrl|escape:'html'}"
                                        title="{translate key=UrlCopiedToClipboard}"
                                        onclick="copyUrlToClipboard('{$atomUrl|escape:'javascript'|escape:'html'}'); return false;">Atom</a>
                                    <div class="vr me-1"></div>
                                    <a class="link-primary" target="_blank" href="{$icalUrl|escape:'html'}"
                                        title="{translate key=UrlCopiedToClipboard}"
                                        onclick="copyUrlToClipboard('{$icalUrl|escape:'javascript'|escape:'html'}'); return false;">iCalendar</a>
                                </div>
                            {/if}
                        {/block}
                    </div>
                {/if}

                <div id="schedule-title" class="schedule_title {$titleWidth}">
                    <div class="d-flex justify-content-center">
                        {if count($Schedules) > 1}
                            <label for="schedules" class="visually-hidden">{translate key='Schedules'}</label>
                            <select id="schedules" class="form-select w-auto">
                                {foreach from=$Schedules item=schedule}
                                    <option value="{$schedule->GetId()}" {if $schedule->GetId() == $ScheduleId}selected="selected"
                                        {/if}>
                                        {$schedule->GetName()}</option>
                                {/foreach}
                            </select>
                        {/if}
                        <a class="link-primary" href="#" id="calendar_toggle" title="{translate key=ShowHideNavigation}"
                            data-bs-toggle="collapse" data-bs-target="#individualDates" aria-expanded="false"
                            aria-controls="individualDates">
                            <span class="bi bi-calendar schedule_icon"></span>
                            <span class="visually-hidden">{translate key=ShowHideNavigation}</span>
                        </a>
                    </div>
                </div>
            </div>

            <div id="individualDates" class="collapse mb-3">
                <div class="d-flex justify-content-center align-items-center mt-2">
                    <div class="form-check form-switch">
                        <input class="form-check-input" type='checkbox' id='multidateselect' />
                        <label class="form-check-label" for='multidateselect'>{translate key=SpecificDates}</label>
                    </div>
                </div>
                <div class="text-center" id="individualDatesList"></div>
                <button class="btn btn-sm btn-primary mx-auto" href="#" id="individualDatesGo">
                    <i class="bi bi-search me-1"></i>{translate key=SpecificDates}
                </button>
                <div class="d-flex justify-content-center align-items-center">
                    <div id="datepicker" class="collapse"></div>
                </div>
            </div>



            {capture name="date_navigation"}
                {if !isset($HideSchedule) || !$HideSchedule}
                    <div class="schedule-dates d-flex justify-content-center mt-2 fs-5 gap-2">
                        {assign var=TodaysDate value=Date::Now()}
                        <a href="#" class="change-date link-primary" data-year="{$TodaysDate->Year()}"
                            data-month="{$TodaysDate->Month()}" data-day="{$TodaysDate->Day()}" aria-label="{translate key=Today}">
                            <i class="bi bi-house-fill" aria-hidden="true"></i>
                        </a>
                        {assign var=FirstDate value=$DisplayDates->GetBegin()}
                        {assign var=LastDate value=$DisplayDates->GetEnd()->AddDays(-1)}
                        <a href="#" class="change-date link-primary" data-year="{$PreviousDate->Year()}"
                            data-month="{$PreviousDate->Month()}" data-day="{$PreviousDate->Day()}"
                            aria-label="{translate key=PreviousWeek}">
                            <i class="bi bi-arrow-left-circle-fill" aria-hidden="true"></i>
                        </a>
                        {formatdate date=$FirstDate}
                        {if $ShowWeekNumbers}({$FirstDate->WeekNumber()}){/if}
                        -
                        {formatdate date=$LastDate}
                        {if $ShowWeekNumbers}({$LastDate->WeekNumber()}){/if}
                        <a href="#" class="change-date link-primary" data-year="{$NextDate->Year()}" data-month="{$NextDate->Month()}"
                            data-day="{$NextDate->Day()}" aria-label="{translate key=NextWeek}">
                            <i class="bi bi-arrow-right-circle-fill" aria-hidden="true"></i>
                        </a>
                    </div>
                    {if $ShowFullWeekLink}
                        <div class="d-flex justify-content-center fs-5">
                            <a class="link-primary" href="{add_querystring key=SHOW_FULL_WEEK value=1}"
                                id="showFullWeek">({translate key=ShowFullWeek})</a>
                        </div>
                    {/if}
                {/if}
            {/capture}

            {$smarty.capture.date_navigation}
        {/block}

        {if isset($ScheduleAvailabilityEarly) && $ScheduleAvailabilityEarly}
            <div class="alert alert-warning text-center">
                <i class="bi bi-exclamation-triangle-fill"></i> {translate key=ScheduleAvailabilityEarly}
                <a href="#" class="change-date alert-link" data-year="{$ScheduleAvailabilityStart->Year()}"
                    data-month="{$ScheduleAvailabilityStart->Month()}" data-day="{$ScheduleAvailabilityStart->Day()}">
                    {format_date date=$ScheduleAvailabilityStart timezone=$timezone}
                </a> -
                <a href="#" class="change-date alert-link" data-year="{$ScheduleAvailabilityEnd->Year()}"
                    data-month="{$ScheduleAvailabilityEnd->Month()}" data-day="{$ScheduleAvailabilityEnd->Day()}">
                    {format_date date=$ScheduleAvailabilityEnd timezone=$timezone}
                </a>
            </div>
        {/if}

        {if isset($ScheduleAvailabilityLate) && $ScheduleAvailabilityLate}
            <div class="alert alert-warning text-center">
                <i class="bi bi-exclamation-triangle-fill"></i>
                {translate key=ScheduleAvailabilityLate}
                <a href="#" class="change-date alert-link" data-year="{$ScheduleAvailabilityStart->Year()}"
                    data-month="{$ScheduleAvailabilityStart->Month()}" data-day="{$ScheduleAvailabilityStart->Day()}">
                    {format_date date=$ScheduleAvailabilityStart timezone=$timezone}
                </a> -
                <a href="#" class="change-date alert-link" data-year="{$ScheduleAvailabilityEnd->Year()}"
                    data-month="{$ScheduleAvailabilityEnd->Month()}" data-day="{$ScheduleAvailabilityEnd->Day()}">
                    {format_date date=$ScheduleAvailabilityEnd timezone=$timezone}
                </a>
            </div>
        {/if}

        {if !isset($HideSchedule) || !$HideSchedule}
            {block name="legend"}
                <div class="schedule-legend mt-3">
                    <div class="d-none d-sm-flex justify-content-center flex-wrap gap-1 text-center">
                        <div
                            class="legend reservable border border-dark-subtle rounded-2 d-flex align-items-center justify-content-center lh-sm py-1">
                            {translate key=Reservable}</div>
                        <div
                            class="legend unreservable border border-dark-subtle rounded-2 d-flex align-items-center justify-content-center lh-sm py-1">
                            {translate key=Unreservable}</div>
                        <div
                            class="legend reserved border border-dark-subtle rounded-2 d-flex align-items-center justify-content-center lh-sm py-1">
                            {translate key=Reserved}</div>
                        {if $LoggedIn}
                            <div
                                class="legend reserved mine border border-dark-subtle rounded-2 d-flex align-items-center justify-content-center lh-sm py-1">
                                {translate key=MyReservation}
                            </div>
                            <div
                                class="legend reserved participating border border-dark-subtle rounded-2 d-flex align-items-center justify-content-center lh-sm py-1">
                                {translate key=Participant}</div>
                        {/if}
                        <div
                            class="legend reserved pending border border-dark-subtle rounded-2 d-flex align-items-center justify-content-center lh-sm py-1">
                            {translate key=Pending}</div>
                        <div
                            class="legend pasttime border border-dark-subtle rounded-2 d-flex align-items-center justify-content-center lh-sm py-1">
                            {translate key=Past}</div>
                        <div
                            class="legend restricted border border-dark-subtle rounded-2 d-flex align-items-center justify-content-center lh-sm py-1">
                            {translate key=Restricted}</div>
                    </div>
                    {* Cenacle Drag & Drop Treatment Tray & Floating Left Dock *}
{literal}
                    <div class="cenacle-drag-tray p-2 my-2 bg-white border rounded shadow-sm">
                        <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                            <div class="d-flex align-items-center gap-1">
                                <span class="badge bg-dark px-2 py-1"><i class="bi bi-arrows-move me-1"></i> Drag to Book:</span>
                                <span class="small text-secondary fw-semibold">Drag any badge onto an open chair or bed slot below:</span>
                            </div>
                            <div class="d-flex flex-wrap gap-2 align-items-center">
                                <div class="cenacle-drag-item text-white shadow-sm" draggable="true"
                                     data-treatment="Foot Reflexology" data-allowed="chair" data-color="#4A90D9"
                                     data-options='[{"duration":30,"price":900,"label":"30 min \u2013 900 Birr","dropdownValue":"Foot Reflexology \u2013 30 min (900 Birr)"},{"duration":60,"price":1300,"label":"1 hour \u2013 1,300 Birr","dropdownValue":"Foot Reflexology \u2013 1 hr (1,300 Birr)","default":true},{"duration":90,"price":2000,"label":"1.5 hr \u2013 2,000 Birr","dropdownValue":"Foot Reflexology \u2013 1.5 hr (2,000 Birr)"}]'
                                     style="background-color:#4A90D9; cursor:grab; padding: 5px 12px; border-radius: 6px;">
                                    <i class="bi bi-hand-index-thumb"></i> <strong>Foot Reflexology</strong> <span class="badge bg-white text-dark ms-1">Chairs 1&ndash;6</span>
                                </div>
                                <div class="cenacle-drag-item text-white shadow-sm" draggable="true"
                                     data-treatment="Full Body Massage" data-allowed="bed" data-color="#8B5CF6"
                                     data-options='[{"duration":60,"price":2000,"label":"1 hour \u2013 2,000 Birr","dropdownValue":"Full Body Massage \u2013 1 hr (2,000 Birr)","default":true}]'
                                     style="background-color:#8B5CF6; cursor:grab; padding: 5px 12px; border-radius: 6px;">
                                    <i class="bi bi-hand-index-thumb"></i> <strong>Full Body Massage</strong> <span class="badge bg-warning text-dark ms-1">BED ONLY</span>
                                </div>
                                <div class="cenacle-drag-item text-white shadow-sm" draggable="true"
                                     data-treatment="Back Massage" data-allowed="bed" data-color="#B07DB0"
                                     data-options='[{"duration":30,"price":1200,"label":"30 min \u2013 1,200 Birr","dropdownValue":"Back Massage \u2013 30 min (1,200 Birr)","default":true}]'
                                     style="background-color:#B07DB0; cursor:grab; padding: 5px 12px; border-radius: 6px;">
                                    <i class="bi bi-hand-index-thumb"></i> <strong>Back Massage</strong> <span class="badge bg-warning text-dark ms-1">BED ONLY</span>
                                </div>
                                <div class="cenacle-drag-item text-white shadow-sm" draggable="true"
                                     data-treatment="Head & Shoulder Massage" data-allowed="chair" data-color="#5FAD8E"
                                     data-options='[{"duration":20,"price":500,"label":"20 min \u2013 500 Birr","dropdownValue":"Head & Shoulder Massage \u2013 20 min (500 Birr)"},{"duration":30,"price":700,"label":"30 min \u2013 700 Birr","dropdownValue":"Head & Shoulder Massage \u2013 30 min (700 Birr)","default":true}]'
                                     style="background-color:#5FAD8E; cursor:grab; padding: 5px 12px; border-radius: 6px;">
                                    <i class="bi bi-hand-index-thumb"></i> <strong>Head &amp; Shoulder</strong> <span class="badge bg-white text-dark ms-1">Chairs 1&ndash;6</span>
                                </div>
                                <div class="cenacle-drag-item text-white shadow-sm" draggable="true"
                                     data-treatment="Hand Reflexology" data-allowed="chair" data-color="#E8865A"
                                     data-options='[{"duration":20,"price":500,"label":"20 min \u2013 500 Birr","dropdownValue":"Hand Reflexology \u2013 20 min (500 Birr)"},{"duration":30,"price":700,"label":"30 min \u2013 700 Birr","dropdownValue":"Hand Reflexology \u2013 30 min (700 Birr)","default":true}]'
                                     style="background-color:#E8865A; cursor:grab; padding: 5px 12px; border-radius: 6px;">
                                    <i class="bi bi-hand-index-thumb"></i> <strong>Hand Reflexology</strong> <span class="badge bg-white text-dark ms-1">Chairs 1&ndash;6</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    {* Floating Left Quick-Book Dock (Stays visible while scrolling week schedule) *}
                    <div id="cenacle-float-dock" class="shadow-lg border rounded-3 bg-white"
                         style="position: fixed; left: 14px; top: 130px; z-index: 1045; width: 220px; transition: all 0.2s ease;">
                        <div class="d-flex align-items-center justify-content-between px-3 py-2 text-white rounded-top-3"
                             style="background-color: #2C6E6E; cursor: pointer;" id="cenacle-dock-header">
                            <div class="d-flex align-items-center gap-2 fw-bold small text-nowrap">
                                <i class="bi bi-arrows-move"></i>
                                <span id="cenacle-dock-title">Quick Book</span>
                            </div>
                            <button type="button" class="btn btn-sm btn-link text-white p-0 text-decoration-none" id="cenacle-dock-toggle" title="Collapse / Expand dock" style="line-height:1;">
                                <i class="bi bi-chevron-left" id="cenacle-dock-icon"></i>
                            </button>
                        </div>
                        <div class="p-2 d-flex flex-column gap-2" id="cenacle-dock-body">
                            <div class="small text-muted px-1" style="font-size:0.75rem;">
                                <i class="bi bi-hand-index-thumb text-primary me-1"></i> Drag onto slot:
                            </div>
                            <div class="cenacle-drag-item text-white shadow-sm p-2 rounded d-flex align-items-center justify-content-between" draggable="true"
                                 data-treatment="Foot Reflexology" data-allowed="chair" data-color="#4A90D9"
                                 data-options='[{"duration":30,"price":900,"label":"30 min \u2013 900 Birr","dropdownValue":"Foot Reflexology \u2013 30 min (900 Birr)"},{"duration":60,"price":1300,"label":"1 hour \u2013 1,300 Birr","dropdownValue":"Foot Reflexology \u2013 1 hr (1,300 Birr)","default":true},{"duration":90,"price":2000,"label":"1.5 hr \u2013 2,000 Birr","dropdownValue":"Foot Reflexology \u2013 1.5 hr (2,000 Birr)"}]'
                                 style="background-color:#4A90D9; cursor:grab; font-size:0.83rem;">
                                <span><i class="bi bi-hand-index-thumb me-1"></i><strong>Foot Reflex</strong></span>
                                <span class="badge bg-white text-dark ms-1" style="font-size:0.7rem;">Chairs 1–6</span>
                            </div>
                            <div class="cenacle-drag-item text-white shadow-sm p-2 rounded d-flex align-items-center justify-content-between" draggable="true"
                                 data-treatment="Full Body Massage" data-allowed="bed" data-color="#8B5CF6"
                                 data-options='[{"duration":60,"price":2000,"label":"1 hour \u2013 2,000 Birr","dropdownValue":"Full Body Massage \u2013 1 hr (2,000 Birr)","default":true}]'
                                 style="background-color:#8B5CF6; cursor:grab; font-size:0.83rem;">
                                <span><i class="bi bi-hand-index-thumb me-1"></i><strong>Full Body</strong></span>
                                <span class="badge bg-warning text-dark ms-1 fw-bold" style="font-size:0.7rem;">BED ONLY</span>
                            </div>
                            <div class="cenacle-drag-item text-white shadow-sm p-2 rounded d-flex align-items-center justify-content-between" draggable="true"
                                 data-treatment="Back Massage" data-allowed="bed" data-color="#B07DB0"
                                 data-options='[{"duration":30,"price":1200,"label":"30 min \u2013 1,200 Birr","dropdownValue":"Back Massage \u2013 30 min (1,200 Birr)","default":true}]'
                                 style="background-color:#B07DB0; cursor:grab; font-size:0.83rem;">
                                <span><i class="bi bi-hand-index-thumb me-1"></i><strong>Back Massage</strong></span>
                                <span class="badge bg-warning text-dark ms-1 fw-bold" style="font-size:0.7rem;">BED ONLY</span>
                            </div>
                            <div class="cenacle-drag-item text-white shadow-sm p-2 rounded d-flex align-items-center justify-content-between" draggable="true"
                                 data-treatment="Head & Shoulder Massage" data-allowed="chair" data-color="#5FAD8E"
                                 data-options='[{"duration":20,"price":500,"label":"20 min \u2013 500 Birr","dropdownValue":"Head & Shoulder Massage \u2013 20 min (500 Birr)"},{"duration":30,"price":700,"label":"30 min \u2013 700 Birr","dropdownValue":"Head & Shoulder Massage \u2013 30 min (700 Birr)","default":true}]'
                                 style="background-color:#5FAD8E; cursor:grab; font-size:0.83rem;">
                                <span><i class="bi bi-hand-index-thumb me-1"></i><strong>Head/Shoulder</strong></span>
                                <span class="badge bg-white text-dark ms-1" style="font-size:0.7rem;">Chairs 1–6</span>
                            </div>
                            <div class="cenacle-drag-item text-white shadow-sm p-2 rounded d-flex align-items-center justify-content-between" draggable="true"
                                 data-treatment="Hand Reflexology" data-allowed="chair" data-color="#E8865A"
                                 data-options='[{"duration":20,"price":500,"label":"20 min \u2013 500 Birr","dropdownValue":"Hand Reflexology \u2013 20 min (500 Birr)"},{"duration":30,"price":700,"label":"30 min \u2013 700 Birr","dropdownValue":"Hand Reflexology \u2013 30 min (700 Birr)","default":true}]'
                                 style="background-color:#E8865A; cursor:grab; font-size:0.83rem;">
                                <span><i class="bi bi-hand-index-thumb me-1"></i><strong>Hand Reflex</strong></span>
                                <span class="badge bg-white text-dark ms-1" style="font-size:0.7rem;">Chairs 1–6</span>
                            </div>
                        </div>
                    </div>
{/literal}
                </div>
            {/block}

            <div>
                <a href="#" title="Show Reservation Filter" class="toggle-sidebar link-primary"><i
                        class="bi bi-funnel-fill me-1"></i>{translate key=ResourceFilter}
                    <i id="restore-sidebar" class="bi bi-chevron-double-right"></i></a>
            </div>
            <div class="row g-2">
                <div id="reservations-left" class="col-md-2 col-sm-12">
                    <div class="card h-100">
                        <div
                            class="reservations-left-header card-header d-flex justify-content-between align-items-center px-3 py-2">
                            <h5 class="card-title text-center mb-0">{translate key=Filter}</h5>
                            <a href="#" class="toggle-sidebar link-primary" title="Hide Reservation Filter">
                                <i class="bi bi-x-circle-fill"></i>
                                <span class="visually-hidden">Hide Reservation Filter</span>
                            </a>
                        </div>

                        <div class="reservations-left-content card-body">
                            <form method="get" role="form" id="advancedFilter">

                                {if count($ResourceAttributes) + count($ResourceTypeAttributes) > 5}
                                    <div>
                                        <input type="submit" value="{translate key=Filter}" class="btn btn-primary btn-sm"
                                            {formname key=SUBMIT} />
                                    </div>
                                {/if}

                                <div>
                                    {*<label>{translate key=Resource}</label>*}
                                    <div id="resourceGroups"></div>
                                </div>

                                <div id="resettable">
                                    {if $CanViewUsers}
                                        <div class="form-group mb-2">
                                            <label for="ownerFilter" class="fw-bold">{translate key=Owner}</label>
                                            <input type='search' id='ownerFilter' class="form-control form-control-sm search"
                                                {formname key=OWNER_TEXT} value="{if isset($OwnerText)}{$OwnerText}{/if}" />
                                            <input {formname key=USER_ID} id="ownerId" type="hidden" value="{$OwnerId}" />
                                            <span class="searchclear searchclear-label" ref="ownerFilter,ownerId"></span>
                                        </div>
                                        {if $AllowParticipation}
                                            <div class="form-group mb-2">
                                                <label for="participantFilter" class="fw-bold">{translate key=Participant}</label>
                                                <input type='search' id='participantFilter' class="form-control form-control-sm search"
                                                    {formname key=PARTICIPANT_TEXT}
                                                    value="{if isset($ParticipantText)}{$ParticipantText}{/if}" />
                                                <input {formname key=PARTICIPANT_ID} id="participantId" type="hidden"
                                                    value="{$ParticipantId}" />
                                                <span class="searchclear searchclear-label"
                                                    ref="participantFilter,participantId"></span>
                                            </div>
                                        {/if}
                                    {/if}
                                    <div class="form-group mb-2">
                                        <label for="maxCapactiy" class="fw-bold">{translate key=MinimumCapacity}</label>
                                        <input type='number' min='0' id='maxCapactiy' size='5' maxlength='5'
                                            class="form-control form-control-sm" {formname key=MAX_PARTICIPANTS}
                                            value="{$MaxParticipantsFilter}" />
                                    </div>

                                    <div class="form-group mb-2">
                                        <label for="resourceType" class="fw-bold">{translate key=ResourceType}</label>
                                        <select id="resourceType" {formname key=RESOURCE_TYPE_ID}
                                            class="form-select form-select-sm">
                                            <option value="">- {translate key=All} -</option>
                                            {object_html_options options=$ResourceTypes label='Name' key='Id' selected=$ResourceTypeIdFilter}
                                        </select>
                                    </div>

                                    {foreach from=$ResourceAttributes item=attribute}
                                        {control type="AttributeControl" attribute=$attribute searchmode=true namePrefix='r' class="customAttribute mb-2"}
                                    {/foreach}

                                    {foreach from=$ResourceTypeAttributes item=attribute}
                                        {control type="AttributeControl" attribute=$attribute searchmode=true namePrefix='rt' class="customAttribute mb-2"}
                                    {/foreach}

                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-primary btn-block btn-sm"
                                            value="submit">{translate key=Filter}</button>
                                        <button id="show_all_resources" type="button"
                                            class="btn btn-outline-secondary btn-sm">{translate key=ClearFilter}</button>
                                    </div>
                                </div>

                                <input type="hidden" name="sid" value="{$ScheduleId}" />
                                <input type="hidden" name="sds"
                                    value="{foreach from=$SpecificDates item=d}{$d->Format('Y-m-d')},{/foreach}" />
                                <input type="hidden" name="sd" value="{$DisplayDates->GetBegin()->Format('Y-m-d')}" />
                                <input type="hidden" {formname key=SUBMIT} value="true" />
                                <input type="hidden" name="clearFilter" id="clearFilter" value="0" />
                            </form>
                        </div>
                    </div>
                </div>

                <div id="reservations" class="col-md-10 col-sm-12">
                    {block name="reservations"}
                        {include file="Schedule/schedule-reservations-grid.tpl" }
                    {/block}
                </div>
            </div>
        {/if}
    {else}
        <div class="error">{translate key=NoResourcePermission}</div>
    {/if}

    <input type="hidden" value="{$ScheduleId}" id="scheduleId" />

    <div class="mt-2">
        {$smarty.capture.date_navigation}
    </div>
    {assign var=endTime value=microtime(true)}

</div>

<form id="moveReservationForm">
    <input id="moveReferenceNumber" type="hidden" {formname key=REFERENCE_NUMBER} />
    <input id="moveStartDate" type="hidden" {formname key=BEGIN_DATE} />
    <input id="moveResourceId" type="hidden" {formname key=RESOURCE_ID} />
    <input id="moveSourceResourceId" type="hidden" {formname key=ORIGINAL_RESOURCE_ID} />
    {csrf_token}
</form>


<form id="fetchReservationsForm">
    <input type="hidden" {formname key=BEGIN_DATE} value="{formatdate date=$FirstDate key=system}" />
    <input type="hidden" {formname key=END_DATE} value="{formatdate date=$LastDate key=system}" />
    <input type="hidden" {formname key=SCHEDULE_ID} value="{$ScheduleId}" />
    {foreach from=$SpecificDates item=d}
        <input type="hidden" {formname key=SPECIFIC_DATES multi=true} value="{formatdate date=$d key=system}" />
    {/foreach}
    <input type="hidden" {formname key=MIN_CAPACITY} value="{if isset($MinCapacityFilter)}{$MinCapacityFilter}{/if}" />
    <input type="hidden" {formname key=RESOURCE_TYPE_ID} value="{$ResourceTypeIdFilter}" />
    {foreach from=$ResourceAttributes item=attribute}
        <input type="hidden" name="RESOURCE_ATTRIBUTE_ID[{$attribute->Id()}]" value="{$attribute->Value()}" />
    {/foreach}
    {foreach from=$ResourceTypeAttributes item=attribute}
        <input type="hidden" name="RESOURCE_TYPE_ATTRIBUTE_ID[{$attribute->Id()}]" value="{$attribute->Value()}" />
    {/foreach}
    {foreach from=$ResourceIds item=id}
        <input type="hidden" {formname key=RESOURCE_ID multi=true} value="{$id}" />
    {/foreach}
    <input type="hidden" {formname key=USER_ID} value="{$UserIdFilter}" />
    <input type="hidden" {formname key=PARTICIPANT_ID} value="{$ParticipantIdFilter}" />
    {csrf_token}
</form>

<div id="loading-schedule" class="d-none d-flex align-items-center gap-2 p-3 border rounded-2 bg-white
opacity-75">
    <div class="spinner-border" role="status">
        <span class="visually-hidden">{translate key='Working'}</span>
    </div>
    <span aria-hidden="true">{translate key='Working'}</span>
</div>

{include file="javascript-includes.tpl" Select2=true Clear=true DatePicker=true}

{block name="scripts-before"}

{/block}

{vendor_js src="html2canvas-pro/2.0.2/js/html2canvas-pro.min.js"}
{jsfile src="reservationPopup.js"}
{jsfile src="schedule.js"}
{jsfile src="resourcePopup.js"}
{vendor_js src="jqtree/1.8.11/js/tree.jquery.js"}
{vendor_js src="jquery-cookie/1.3.1/js/jquery.cookie.js"}
{jsfile src="autocomplete.js"}
{jsfile src="ajax-helpers.js"}
<script type="text/javascript">
    let resourceMaxConcurrentReservations = {};
    {foreach from=$Resources item=r}
        resourceMaxConcurrentReservations[{$r->GetId()}] = {$r->MaxConcurrentReservations};
    {/foreach}


    const scheduleOpts = {
        reservationUrlTemplate: "{$Path}{Pages::RESERVATION}?{QueryStringKeys::REFERENCE_NUMBER}=[referenceNumber]",
        summaryPopupUrl: "{$Path}ajax/respopup.php",
        setDefaultScheduleUrl: "{$Path}{Pages::PROFILE}?action=changeDefaultSchedule&{QueryStringKeys::SCHEDULE_ID}=[scheduleId]",
        cookieName: "{$CookieName}",
        scheduleId: "{$ScheduleId|escape:'javascript'}",
        scriptUrl: '{$ScriptUrl}',
        selectedResources: [{$ResourceIds|join:','}],
        specificDates: [{foreach from=$SpecificDates item=d}'{$d->Format('Y-m-d')}',{/foreach}],
        updateReservationUrl: "{$Path}ajax/reservation_move.php",
        lockTableHead: "{if isset($LockTableHead)}{$LockTableHead}{/if}",
        disableSelectable: "{$IsMobile}",
        reservationLoadUrl: "{$Path}{Pages::SCHEDULE}?{QueryStringKeys::DATA_REQUEST}=reservations",
        scheduleStyle: "{$ScheduleStyle}",
        midnightLabel: "{formatdate date=Date::Now()->GetDate() key=period_time}",
        isMobileView: "{$IsMobile && !$IsTablet}",
        newLabel: "{translate key=New}",
        updatedLabel: "{translate key=Updated}",
        isReservable: 1,
        autocompleteUrl: "{$Path}ajax/autocomplete.php?type={AutoCompleteType::User}",
        fastReservationLoad: "{$FastReservationLoad}",
        resourceMaxConcurrentReservations,
        autoScrollToday: {$AutoScrollToday|@json_encode},
        altFormatDate: "{Resources::GetInstance()->GetDateFormat('schedule_daily')}",
    };

    const resourceOrder = [];
    let resourceIndex = 0;
    {foreach from=$Resources item=r}
        resourceOrder[{$r->GetId()}] = resourceIndex++;
    {/foreach}
    scheduleOpts.resourceOrder = resourceOrder;

    {if $LoadViewOnly}
        scheduleOpts.reservationUrlTemplate = "view-reservation.php?{QueryStringKeys::REFERENCE_NUMBER}=[referenceNumber]";
        scheduleOpts.reservationLoadUrl = "{$Path}{Pages::VIEW_SCHEDULE}?{QueryStringKeys::DATA_REQUEST}=reservations";
        scheduleOpts.isReservable = {if $AllowGuestBooking}1{else}0{/if};
    {/if}

    $(document).ready(function() {
        const schedule = new Schedule(scheduleOpts, {$ResourceGroupsAsJson});
        schedule.init();

    });

    $('#schedules').select2({
        width: 'resolve'
    });
</script>

{block name="scripts-after"}

{/block}


{control type="DatePickerSetupControl"
ControlId='datepicker'
AltInput=false
Inline=true
DefaultDate=$FirstDate
NumberOfMonths=$PopupMonths
ShowButtonPanel='true'
OnSelect='dpDateChanged'
FirstDay=$FirstWeekday}

{* ── Cenacle Drag & Drop Intake Modal ── *}
<div class="modal fade" id="cenacleIntakeModal" tabindex="-1" aria-labelledby="cenacleIntakeModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content shadow-lg border-0">
            <div class="modal-header text-white" id="cenacleIntakeModalHeader" style="background-color:#2C6E6E;">
                <h5 class="modal-title d-flex align-items-center gap-2" id="cenacleIntakeModalLabel">
                    <i class="bi bi-calendar-check"></i>
                    <span>Cenacle Quick Intake</span>
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <!-- Target slot summary card -->
                <div class="p-3 mb-3 rounded bg-light border d-flex justify-content-between align-items-center">
                    <div>
                        <div class="fw-bold text-dark fs-6" id="cenacleIntakeResourceName">Chair 1</div>
                        <div class="text-muted small" id="cenacleIntakeSlotTime"><i class="bi bi-clock me-1"></i> Starting: <strong>14:30</strong></div>
                    </div>
                    <span class="badge py-2 px-3 fs-6 text-white" id="cenacleIntakeTreatmentBadge" style="background-color:#4A90D9;">Foot Reflexology</span>
                </div>

                <form id="cenacleIntakeForm" onsubmit="return false;">
                    <!-- Duration & Pricing -->
                    <div class="mb-3">
                        <label class="form-label fw-bold mb-1"><i class="bi bi-tag me-1 text-primary"></i> Select Duration &amp; Price <span class="text-danger">*</span></label>
                        <div id="cenacleDurationOptionsContainer" class="d-flex flex-column gap-2">
                            <!-- Populated dynamically -->
                        </div>
                    </div>

                    <!-- Customer Name -->
                    <div class="mb-3">
                        <label for="cenacleCustomerName" class="form-label fw-bold mb-1">
                            <i class="bi bi-person me-1 text-primary"></i> Customer Name <span class="text-danger">*</span>
                        </label>
                        <input type="text" class="form-control" id="cenacleCustomerName" placeholder="e.g. Abebe Kebede" required autocomplete="off">
                        <div class="invalid-feedback">Please enter customer name.</div>
                    </div>

                    <!-- Phone & Persons -->
                    <div class="row g-2 mb-3">
                        <div class="col-7">
                            <label for="cenacleCustomerPhone" class="form-label fw-bold mb-1">
                                <i class="bi bi-telephone me-1 text-primary"></i> Phone Number
                            </label>
                            <input type="tel" class="form-control" id="cenacleCustomerPhone" placeholder="0911 23 45 67">
                        </div>
                        <div class="col-5">
                            <label for="cenacleCustomerPersons" class="form-label fw-bold mb-1">
                                <i class="bi bi-people me-1 text-primary"></i> Persons
                            </label>
                            <input type="number" class="form-control" id="cenacleCustomerPersons" min="1" max="10" value="1" required>
                        </div>
                    </div>

                    <!-- Notes -->
                    <div class="mb-3">
                        <label for="cenacleCustomerNotes" class="form-label fw-bold mb-1">
                            <i class="bi bi-chat-left-text me-1 text-primary"></i> Notes / Special Requests
                        </label>
                        <textarea class="form-control" id="cenacleCustomerNotes" rows="2" placeholder="e.g. Medium pressure, first-time client..."></textarea>
                    </div>

                    <!-- Buffer notice -->
                    <div class="alert alert-secondary py-2 px-3 small d-flex align-items-center gap-2 mb-3">
                        <i class="bi bi-shield-check text-success fs-5"></i>
                        <div>
                            <strong>Zero Double-Booking:</strong> A 5-minute cleaning buffer will automatically follow this booking.
                        </div>
                    </div>

                    <!-- Auto-submit checkbox -->
                    <div class="form-check mb-1">
                        <input class="form-check-input" type="checkbox" id="cenacleAutoSubmitCheck" checked>
                        <label class="form-check-label small" for="cenacleAutoSubmitCheck">
                            Auto-create immediately without extra clicks
                        </label>
                    </div>
                </form>
            </div>
            <div class="modal-footer bg-light">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary px-4 fw-bold" id="cenacleConfirmBookBtn" style="background-color:#2C6E6E;border-color:#2C6E6E;">
                    <i class="bi bi-check2-circle me-1"></i> Confirm &amp; Book
                </button>
            </div>
        </div>
    </div>
</div>

{* ── Cenacle Placement Restriction Alert Modal ── *}
<div class="modal fade" id="cenacleRuleAlertModal" tabindex="-1" aria-labelledby="cenacleRuleAlertModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content shadow border-0">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title d-flex align-items-center gap-2" id="cenacleRuleAlertModalLabel">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                    <span>Placement Restriction</span>
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4 text-center">
                <div class="mb-3 text-danger fs-1">
                    <i class="bi bi-slash-circle"></i>
                </div>
                <div id="cenacleRuleAlertMessage" class="fs-6 text-dark">
                </div>
            </div>
            <div class="modal-footer justify-content-center bg-light">
                <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Understood</button>
            </div>
        </div>
    </div>
</div>

{literal}
<script type="text/javascript">
// ═══════════════════════════════════════════════════════════════════
// Cenacle Drag-and-Drop Booking & Floating Dock Engine
// ═══════════════════════════════════════════════════════════════════
(function () {
    'use strict';

    window._cenacle = {
        drag: null,
        slot: null
    };

    // ── Helper: Find reservable target element (TD or DIV) ───────────
    function getReservableElement(el) {
        var node = el;
        while (node && node !== document) {
            if (node.classList && node.classList.contains('reservable')) {
                return node;
            }
            node = node.parentElement;
        }
        return null;
    }

    // ── Helper: Extract Resource ID from cell, href, or row ──────────
    function getResourceId(el) {
        if (!el) return '';
        var rid = el.getAttribute('data-resourceid') ||
                  el.getAttribute('data-resourceId') ||
                  el.getAttribute('resourceid') ||
                  el.getAttribute('resourceId') ||
                  (el.dataset ? (el.dataset.resourceid || el.dataset.resourceId) : '');
        if (rid) return String(rid).trim();

        // Check href/ref attribute (e.g., reservation.php?rid=7&...)
        var href = el.getAttribute('data-href') || el.getAttribute('ref') || '';
        var m = href.match(/[?&]rid=([0-9]+)/i);
        if (m && m[1]) return String(m[1]).trim();

        // Check row
        var row = el.closest ? el.closest('tr') : null;
        if (row) {
            rid = row.getAttribute('data-resourceid') ||
                  row.getAttribute('data-resourceId') ||
                  row.getAttribute('resourceid') ||
                  row.getAttribute('resourceId');
            if (rid) return String(rid).trim();

            var resEl = row.querySelector('[resourceid], [data-resourceid], .resourceNameSelector, .resourcename a, .resourcename span');
            if (resEl) {
                rid = resEl.getAttribute('resourceid') ||
                      resEl.getAttribute('resourceId') ||
                      resEl.getAttribute('data-resourceid') ||
                      resEl.getAttribute('data-resourceId');
                if (rid) return String(rid).trim();
                var linkHref = resEl.getAttribute('href') || '';
                m = linkHref.match(/[?&]rid=([0-9]+)/i);
                if (m && m[1]) return String(m[1]).trim();
            }
        }
        return '';
    }

    // ── Helper: Find Resource Info (Name & isBed) ────────────────────
    function findResourceInfo(el, rid) {
        var name = '';
        var row = el ? (el.closest ? el.closest('tr') : null) : null;
        if (row) {
            var nameEl = row.querySelector('.resourcename a, .resourcename span, .resourcename, .resourceNameSelector');
            if (nameEl && nameEl.textContent.trim()) {
                name = nameEl.textContent.trim();
            }
        }
        if (!name && rid) {
            var pageEl = document.querySelector('[resourceid="' + rid + '"], [data-resourceid="' + rid + '"]');
            if (pageEl && pageEl.textContent.trim()) {
                name = pageEl.textContent.trim();
            }
        }
        if (!name) {
            name = (String(rid) === '7') ? 'Massage Bed' : ('Resource #' + rid);
        }

        var isBed = name.toLowerCase().indexOf('bed') !== -1 ||
                    name.toLowerCase().indexOf('massage') !== -1 ||
                    String(rid) === '7';

        return { name: name, isBed: isBed, resourceId: rid };
    }

    function clearHighlights() {
        var cells = document.querySelectorAll('.reservable.cenacle-drop-hover, .reservable.cenacle-drop-invalid');
        for (var i = 0; i < cells.length; i++) {
            cells[i].classList.remove('cenacle-drop-hover', 'cenacle-drop-invalid');
        }
    }

    function isBlockedCell(el) {
        return el.classList.contains('reserved') ||
               el.classList.contains('pasttime') ||
               el.classList.contains('unreservable') ||
               el.classList.contains('restricted');
    }

    function showModal(id) {
        var el = document.getElementById(id);
        if (!el) return;
        try {
            var m = window.bootstrap && bootstrap.Modal.getInstance(el);
            if (m) { m.show(); return; }
            m = new bootstrap.Modal(el, { backdrop: true, keyboard: true, focus: true });
            m.show();
        } catch (err) {
            el.style.display = 'block';
            el.classList.add('show');
            el.removeAttribute('aria-hidden');
            document.body.classList.add('modal-open');
            var backdrop = document.createElement('div');
            backdrop.className = 'modal-backdrop fade show';
            backdrop.id = 'cenacle-backdrop';
            document.body.appendChild(backdrop);
            el.addEventListener('click', function handler(evt) {
                if (evt.target === el || evt.target.dataset.bsDismiss === 'modal') {
                    hideModalVanilla(id);
                    el.removeEventListener('click', handler);
                }
            });
        }
    }

    function hideModalVanilla(id) {
        var el = document.getElementById(id);
        if (!el) return;
        el.style.display = 'none';
        el.classList.remove('show');
        el.setAttribute('aria-hidden', 'true');
        document.body.classList.remove('modal-open');
        var bd = document.getElementById('cenacle-backdrop');
        if (bd && bd.parentElement) bd.parentElement.removeChild(bd);
    }

    // ── 1. DragStart ────────────────────────────────────────────────
    document.addEventListener('dragstart', function (e) {
        var item = e.target;
        while (item && item !== document) {
            if (item.classList && item.classList.contains('cenacle-drag-item')) break;
            item = item.parentElement;
        }
        if (!item || !item.classList.contains('cenacle-drag-item')) {
            window._cenacle.drag = null;
            return;
        }

        var optionsRaw = item.getAttribute('data-options');
        var options = [];
        try { options = JSON.parse(optionsRaw); } catch (err) { options = []; }

        window._cenacle.drag = {
            name:    item.getAttribute('data-treatment'),
            allowed: item.getAttribute('data-allowed'),
            color:   item.getAttribute('data-color'),
            options: options
        };

        try {
            e.dataTransfer.setData('text/plain', '__cenacle__');
            e.dataTransfer.effectAllowed = 'copy';
        } catch (err) {}

        item.style.opacity = '0.6';
    }, true);

    // ── 2. DragEnd ──────────────────────────────────────────────────
    document.addEventListener('dragend', function (e) {
        setTimeout(function () {
            window._cenacle.drag = null;
            clearHighlights();
        }, 150);

        var item = e.target;
        while (item && item !== document) {
            if (item.classList && item.classList.contains('cenacle-drag-item')) break;
            item = item.parentElement;
        }
        if (item && item.classList.contains('cenacle-drag-item')) {
            item.style.opacity = '1';
        }
    }, true);

    // ── 3. DragOver ─────────────────────────────────────────────────
    window.addEventListener('dragover', function (e) {
        if (!window._cenacle.drag) return;
        var targetEl = getReservableElement(e.target);
        if (!targetEl || isBlockedCell(targetEl)) return;

        e.preventDefault();
        e.stopPropagation();

        var rid  = getResourceId(targetEl);
        var info = findResourceInfo(targetEl, rid);
        var allowed = window._cenacle.drag.allowed;

        var valid = true;
        if (allowed === 'bed' && !info.isBed) valid = false;
        if (allowed === 'chair' && info.isBed) valid = false;

        if (valid) {
            targetEl.classList.add('cenacle-drop-hover');
            targetEl.classList.remove('cenacle-drop-invalid');
            e.dataTransfer.dropEffect = 'copy';
        } else {
            targetEl.classList.add('cenacle-drop-invalid');
            targetEl.classList.remove('cenacle-drop-hover');
            e.dataTransfer.dropEffect = 'none';
        }
    }, true);

    // ── 4. DragLeave ────────────────────────────────────────────────
    window.addEventListener('dragleave', function (e) {
        if (!window._cenacle.drag) return;
        var targetEl = getReservableElement(e.target);
        if (targetEl) targetEl.classList.remove('cenacle-drop-hover', 'cenacle-drop-invalid');
    }, true);

    // ── 5. Drop: Window Capture ─────────────────────────────────────
    window.addEventListener('drop', function (e) {
        if (!window._cenacle.drag) return;
        var targetEl = getReservableElement(e.target);
        if (!targetEl || isBlockedCell(targetEl)) return;

        e.preventDefault();
        e.stopPropagation();
        e.stopImmediatePropagation();

        targetEl.classList.remove('cenacle-drop-hover', 'cenacle-drop-invalid');

        var drag = window._cenacle.drag;
        var rid  = getResourceId(targetEl);
        var info = findResourceInfo(targetEl, rid);
        var isBed = info.isBed;
        var resName = info.name;

        // Validation: Bed vs Chair
        if (drag.allowed === 'bed' && !isBed) {
            document.getElementById('cenacleRuleAlertMessage').innerHTML =
                '<strong>"' + drag.name + '" must be scheduled on the Massage Bed.</strong><br><br>' +
                'Chairs 1\u20136 are designated exclusively for Foot &amp; Hand Reflexology and Head &amp; Shoulder treatments.<br>' +
                'Please drag this treatment onto the <strong>Massage Bed</strong> row.';
            showModal('cenacleRuleAlertModal');
            window._cenacle.drag = null;
            return;
        }

        if (drag.allowed === 'chair' && isBed) {
            document.getElementById('cenacleRuleAlertMessage').innerHTML =
                '<strong>"' + drag.name + '" cannot be booked on the Massage Bed.</strong><br><br>' +
                'The Massage Bed is exclusively reserved for Full Body and Back Massages.<br>' +
                'Please drag this treatment onto one of the <strong>Chairs (1\u20136)</strong>.';
            showModal('cenacleRuleAlertModal');
            window._cenacle.drag = null;
            return;
        }

        // Slot date & time
        var startStr = '';
        try { startStr = decodeURIComponent(targetEl.getAttribute('data-start') || ''); } catch(err) { startStr = targetEl.getAttribute('data-start') || ''; }
        if (!startStr) {
            var hrefVal = targetEl.getAttribute('data-href') || targetEl.getAttribute('ref') || '';
            var mDate = hrefVal.match(/[?&]rd=([^&]+)/i);
            var mTime = hrefVal.match(/[?&]sd=([^&]+)/i);
            if (mTime) startStr = decodeURIComponent(mTime[1]);
            else if (mDate) startStr = decodeURIComponent(mDate[1]);
        }

        var href = targetEl.getAttribute('data-href') || targetEl.getAttribute('ref') || '';

        window._cenacle.slot = {
            resourceId:   rid || (isBed ? '7' : '1'),
            resourceName: resName,
            isBed:        isBed,
            startStr:     startStr,
            href:         href,
            treatment:    drag
        };

        window._cenacle.drag = null;
        showCenacleIntakeModal(window._cenacle.slot);
    }, true);

    // ── 6. Intake Modal ─────────────────────────────────────────────
    function showCenacleIntakeModal(data) {
        var resNameEl = document.getElementById('cenacleIntakeResourceName');
        if (resNameEl) resNameEl.textContent = data.resourceName;

        var startDisplay = data.startStr;
        try {
            var parts = data.startStr.split(' ');
            if (parts.length >= 2) startDisplay = parts[0] + ' at ' + parts[1].substring(0, 5);
        } catch(err) {}

        var slotTimeEl = document.getElementById('cenacleIntakeSlotTime');
        if (slotTimeEl) slotTimeEl.innerHTML = '<i class="bi bi-clock me-1"></i> Starting: <strong>' + startDisplay + '</strong>';

        var badge = document.getElementById('cenacleIntakeTreatmentBadge');
        if (badge) {
            badge.textContent = data.treatment.name;
            badge.style.backgroundColor = data.treatment.color;
        }

        var container = document.getElementById('cenacleDurationOptionsContainer');
        if (container) {
            container.innerHTML = '';
            var opts = data.treatment.options;
            if (!Array.isArray(opts)) opts = [];

            opts.forEach(function (opt, idx) {
                var isChecked = opt.default || idx === 0;
                var radioId   = 'cenacle_opt_' + idx;
                var labelEl   = document.createElement('label');
                labelEl.htmlFor = radioId;
                labelEl.className = 'list-group-item d-flex justify-content-between align-items-center p-2 rounded border' +
                                    (isChecked ? ' border-primary bg-light' : '');
                labelEl.style.cursor = 'pointer';
                labelEl.innerHTML =
                    '<div class="d-flex align-items-center gap-2">' +
                        '<input class="form-check-input cenacle-duration-radio" type="radio" name="cenacle_duration" ' +
                               'id="' + radioId + '" value="' + opt.duration + '" ' +
                               'data-price="' + opt.price + '" data-label="' + (opt.label || '') + '" ' +
                               'data-dropdown="' + (opt.dropdownValue || '') + '"' +
                               (isChecked ? ' checked' : '') + '>' +
                        '<span class="fw-semibold text-dark">' + (opt.label || '') + '</span>' +
                    '</div>' +
                    '<span class="badge bg-secondary">' + opt.price + ' Birr</span>';
                container.appendChild(labelEl);
            });

            container.addEventListener('change', function (e) {
                if (e.target.classList.contains('cenacle-duration-radio')) {
                    var labels = container.querySelectorAll('label');
                    labels.forEach(function (l) { l.classList.remove('border-primary', 'bg-light'); });
                    e.target.closest('label').classList.add('border-primary', 'bg-light');
                }
            });
        }

        ['cenacleCustomerName','cenacleCustomerPhone','cenacleCustomerNotes'].forEach(function (id) {
            var el = document.getElementById(id);
            if (el) { el.value = ''; el.classList.remove('is-invalid'); }
        });
        var personsEl = document.getElementById('cenacleCustomerPersons');
        if (personsEl) personsEl.value = '1';

        showModal('cenacleIntakeModal');

        var modalEl = document.getElementById('cenacleIntakeModal');
        if (modalEl) {
            modalEl.addEventListener('shown.bs.modal', function focusName() {
                modalEl.removeEventListener('shown.bs.modal', focusName);
                var nameEl = document.getElementById('cenacleCustomerName');
                if (nameEl) nameEl.focus();
            });
        }
    }

    // ── 7. DOM Ready & Event Handlers ───────────────────────────────
    document.addEventListener('DOMContentLoaded', function () {
        // Confirm & Book Button
        var confirmBtn = document.getElementById('cenacleConfirmBookBtn');
        if (confirmBtn) {
            confirmBtn.addEventListener('click', function () {
                var nameEl = document.getElementById('cenacleCustomerName');
                var name   = nameEl ? nameEl.value.trim() : '';
                if (!name) {
                    if (nameEl) { nameEl.classList.add('is-invalid'); nameEl.focus(); }
                    return;
                }
                if (nameEl) nameEl.classList.remove('is-invalid');

                var radio = document.querySelector('input[name="cenacle_duration"]:checked');
                if (!radio) return;

                var durationMinutes = parseInt(radio.value || '60', 10);
                var durationLabel   = radio.getAttribute('data-label') || '';
                var price           = radio.getAttribute('data-price') || '';
                var dropdownVal     = radio.getAttribute('data-dropdown') || '';

                var phone   = (document.getElementById('cenacleCustomerPhone')   || {}).value || '';
                var persons = (document.getElementById('cenacleCustomerPersons') || {}).value || '1';
                var notes   = (document.getElementById('cenacleCustomerNotes')   || {}).value || '';
                var autoChk = document.getElementById('cenacleAutoSubmitCheck');
                var autoSubmit = autoChk ? autoChk.checked : true;

                var slot = window._cenacle.slot;
                if (!slot) return;

                var startStr = slot.startStr;
                var startObj = new Date(startStr.replace(/-/g, '/'));
                if (isNaN(startObj.getTime())) {
                    startObj = new Date();
                }
                var endObj   = new Date(startObj.getTime() + durationMinutes * 60000);

                function p2(n) { return (n < 10 ? '0' : '') + n; }
                var endStr = endObj.getFullYear() + '-' + p2(endObj.getMonth()+1) + '-' + p2(endObj.getDate()) +
                             ' ' + p2(endObj.getHours()) + ':' + p2(endObj.getMinutes()) + ':' + p2(endObj.getSeconds());

                if (!dropdownVal) dropdownVal = slot.treatment.name + ' \u2013 ' + durationLabel;

                var payload = {
                    treatment:       slot.treatment.name,
                    dropdownValue:   dropdownVal,
                    durationMinutes: durationMinutes,
                    durationLabel:   durationLabel,
                    price:           price,
                    customerName:    name,
                    phone:           phone.trim(),
                    persons:         persons.trim(),
                    notes:           notes.trim(),
                    autoSubmit:      autoSubmit,
                    resourceId:      slot.resourceId,
                    resourceName:    slot.resourceName,
                    startDate:       startStr,
                    endDate:         endStr
                };

                sessionStorage.setItem('cenacle_intake_payload', JSON.stringify(payload));

                var targetUrl = slot.href || ('reservation.php?rid=' + slot.resourceId);
                if (targetUrl.indexOf('rid=') === -1 && slot.resourceId) {
                    targetUrl += (targetUrl.indexOf('?') === -1 ? '?' : '&') + 'rid=' + encodeURIComponent(slot.resourceId);
                }
                targetUrl += (targetUrl.indexOf('?') === -1 ? '?' : '&') + 'sd=' + encodeURIComponent(startStr) + '&ed=' + encodeURIComponent(endStr);
                window.location.href = targetUrl;
            });
        }

        // Floating Dock Toggle Logic
        var dock = document.getElementById('cenacle-float-dock');
        var toggleBtn = document.getElementById('cenacle-dock-toggle');
        var dockHeader = document.getElementById('cenacle-dock-header');
        var dockBody = document.getElementById('cenacle-dock-body');
        var dockTitle = document.getElementById('cenacle-dock-title');
        var dockIcon = document.getElementById('cenacle-dock-icon');

        function setDockCollapsed(collapsed) {
            if (!dock) return;
            if (collapsed) {
                dock.style.width = '44px';
                if (dockBody) dockBody.style.display = 'none';
                if (dockTitle) dockTitle.style.display = 'none';
                if (dockIcon) dockIcon.className = 'bi bi-chevron-right';
                dock.setAttribute('data-collapsed', 'true');
            } else {
                dock.style.width = '220px';
                if (dockBody) dockBody.style.display = 'flex';
                if (dockTitle) dockTitle.style.display = 'inline';
                if (dockIcon) dockIcon.className = 'bi bi-chevron-left';
                dock.removeAttribute('data-collapsed');
            }
            try { localStorage.setItem('cenacle_dock_collapsed', collapsed ? '1' : '0'); } catch(e) {}
        }

        if (toggleBtn) {
            toggleBtn.addEventListener('click', function (e) {
                e.stopPropagation();
                var isCol = dock.getAttribute('data-collapsed') === 'true';
                setDockCollapsed(!isCol);
            });
        }
        if (dockHeader) {
            dockHeader.addEventListener('click', function () {
                var isCol = dock.getAttribute('data-collapsed') === 'true';
                if (isCol) setDockCollapsed(false);
            });
        }

        try {
            if (localStorage.getItem('cenacle_dock_collapsed') === '1') {
                setDockCollapsed(true);
            }
        } catch(e) {}

        // Badge click hint
        var badges = document.querySelectorAll('.cenacle-drag-item');
        badges.forEach(function (badge) {
            badge.addEventListener('click', function () {
                var n = badge.getAttribute('data-treatment') || 'this treatment';
                var t = badge.getAttribute('data-allowed') === 'bed' ? 'the Massage Bed' : 'any Chair (1\u20136)';
                alert('\u{1F4A1} Drag and drop "' + n + '" onto an open slot on ' + t + ' to book!');
            });
        });
    });

}());
</script>
{/literal}

{include file='globalfooter.tpl'}
