{block name="header"}
    {include file='globalheader.tpl' cssFiles='css/schedule.css' printCssFiles='css/reservation.print.css'}
{/block}

{function name="displayResource"}
    <div class="resourceName rounded-1 m-1 p-1 {if !$resource->GetColor()}text-success bg-success bg-opacity-10" {else}"
    style="background-color:{$resource->GetColor()};color:{$resource->GetTextColor()}" {/if}>
    <span class="resourceDetails" data-resourceId="{$resource->GetId()}">{$resource->Name}</span>
    {if $resource->GetRequiresApproval()}<span class="bi bi-lock-fill" data-bs-toggle="tooltip"
        data-bs-title="approval"></span>{/if}
    {if $resource->IsCheckInEnabled()}<i class="bi bi-box-arrow-in-right" data-bs-toggle="tooltip"
        data-bs-title="checkin"></i>{/if}
    {if $resource->IsAutoReleased()}<i class="bi bi-clock-history" data-bs-toggle="tooltip" data-bs-title="autorelease"
        data-autorelease="{$resource->GetAutoReleaseMinutes()}"></i>{/if}
</div>
{/function}

<div id="page-reservation">
    <div id="reservation-box" class="mx-3">
        <form id="form-reservation" method="post" enctype="multipart/form-data" role="form">

            <div class="d-flex align-items-center justify-content-between border-bottom my-3 py-2">
                <div class="reservationHeader">
                    <h3 class="mb-0">{block name=reservationHeader}{translate key="CreateReservationHeading"}{/block}
                    </h3>
                    {if !empty($ReferenceNumber)}
                        <div class="form-group">
                            <label class="fw-bold">{translate key=ReferenceNumber}</label>
                            {$ReferenceNumber}
                        </div>
                    {/if}
                </div>
                <div class="float-end buttonsEdit">
                    <button type="button" class="btn btn-sm btn-outline-secondary"
                        onclick="window.location='{$ReturnUrl}'">
                        <i class="bi bi-arrow-left-circle-fill"></i>
                        <span>{translate key='Cancel'}</span>
                    </button>
                    {block name="submitButtons"}
                    <button type="button" class="btn btn-sm btn-primary save create btnCreate">
                        <i class="bi bi-check-circle"></i>
                        {translate key='Create'}
                    </button>
                    {/block}
                </div>
            </div>

            {* Cenacle Services & Pricing Quick Reference *}
            <div class="cenacle-quick-pricing my-2 p-2 border rounded bg-white shadow-sm">
                <div class="d-flex align-items-center justify-content-between">
                    <span class="fw-bold" style="color:var(--cenacle-primary,#2C6E6E);font-size:0.85rem;">
                        <i class="bi bi-tag-fill me-1"></i> Cenacle Services, Pricing &amp; Bed Allocation Guide
                    </span>
                    <button class="btn btn-sm btn-outline-secondary py-0 px-2" type="button" data-bs-toggle="collapse" data-bs-target="#cenaclePricingGuide" aria-expanded="true" style="font-size:0.75rem;">
                        Show / Hide Menu
                    </button>
                </div>
                <div class="collapse show mt-2 pt-2 border-top" id="cenaclePricingGuide">
                    <div class="row g-2 text-start" style="font-size:0.78rem;">
                        <div class="col-md-3 col-sm-6">
                            <div class="p-2 rounded border" style="background:#f0f7ff;border-color:#b9d9fc !important;">
                                <div class="fw-bold text-primary mb-1"><span style="display:inline-block;width:10px;height:10px;border-radius:2px;background:#4A90D9;" class="me-1"></span> Foot Reflexology <span class="badge bg-secondary ms-1">Chairs 1–6</span></div>
                                <div>• 30 min: <strong>900 Birr</strong></div>
                                <div>• 1 hour: <strong>1,300 Birr</strong></div>
                                <div>• 1h 30m: <strong>2,000 Birr</strong></div>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6">
                            <div class="p-2 rounded border" style="background:#faf5ff;border-color:#e2d4fd !important;">
                                <div class="fw-bold mb-1" style="color:#6d28d9;"><span style="display:inline-block;width:10px;height:10px;border-radius:2px;background:#8B5CF6;" class="me-1"></span> Body Massages <span class="badge bg-danger ms-1">BED ONLY</span></div>
                                <div>• 30 min Back: <strong>1,200 Birr</strong></div>
                                <div>• 1 hr Full Body: <strong>2,000 Birr</strong></div>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6">
                            <div class="p-2 rounded border" style="background:#f0fdf4;border-color:#bbf7d0 !important;">
                                <div class="fw-bold mb-1" style="color:#15803d;"><span style="display:inline-block;width:10px;height:10px;border-radius:2px;background:#5FAD8E;" class="me-1"></span> Head &amp; Shoulder <span class="badge bg-secondary ms-1">Chairs 1–6</span></div>
                                <div>• 20 min: <strong>500 Birr</strong></div>
                                <div>• 30 min: <strong>700 Birr</strong></div>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6">
                            <div class="p-2 rounded border" style="background:#fff7ed;border-color:#fed7aa !important;">
                                <div class="fw-bold mb-1" style="color:#c2410c;"><span style="display:inline-block;width:10px;height:10px;border-radius:2px;background:#E8865A;" class="me-1"></span> Hand Reflexology <span class="badge bg-secondary ms-1">Chairs 1–6</span></div>
                                <div>• 20 min: <strong>500 Birr</strong></div>
                                <div>• 30 min: <strong>700 Birr</strong></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row gx-2">
                <!-- Cenacle Treatment Dropdown & Customer Name Section -->
                <div class="col-12 py-3 border-bottom">
                    <div class="p-3 rounded bg-white border shadow-sm" style="border-left: 5px solid #2C6E6E !important;">
                        <div class="row g-3">
                            <div class="col-md-7 col-12">
                                <label class="fw-bold mb-1 d-flex align-items-center gap-1 text-dark fs-6" for="cenacleTreatmentSelect">
                                    <i class="bi bi-tag-fill text-success"></i>
                                    <span>Select Treatment Type</span>
                                    <span class="text-danger">*</span>
                                </label>
                                <select id="cenacleTreatmentSelect" class="form-select form-select-md border-primary-subtle fw-semibold">
                                    <option value="">-- Choose Treatment / Service --</option>
                                    <optgroup label="Foot Reflexology (Chairs 1–6)">
                                        <option value="Foot Reflexology – 30 min (900 Birr)" data-minutes="30" data-price="900">Foot Reflexology – 30 min (900 Birr)</option>
                                        <option value="Foot Reflexology – 1 hr (1,300 Birr)" data-minutes="60" data-price="1300">Foot Reflexology – 1 hr (1,300 Birr)</option>
                                        <option value="Foot Reflexology – 1.5 hr (2,000 Birr)" data-minutes="90" data-price="2000">Foot Reflexology – 1.5 hr (2,000 Birr)</option>
                                    </optgroup>
                                    <optgroup label="Body & Back Massages (Massage Bed Only)">
                                        <option value="Full Body Massage – 1 hr (2,000 Birr)" data-minutes="60" data-price="2000">Full Body Massage – 1 hr (2,000 Birr)</option>
                                        <option value="Back Massage – 30 min (1,200 Birr)" data-minutes="30" data-price="1200">Back Massage – 30 min (1,200 Birr)</option>
                                    </optgroup>
                                    <optgroup label="Head, Shoulder & Hand Reflexology (Chairs 1–6)">
                                        <option value="Head & Shoulder Massage – 20 min (500 Birr)" data-minutes="20" data-price="500">Head & Shoulder Massage – 20 min (500 Birr)</option>
                                        <option value="Head & Shoulder Massage – 30 min (700 Birr)" data-minutes="30" data-price="700">Head & Shoulder Massage – 30 min (700 Birr)</option>
                                        <option value="Hand Reflexology – 20 min (500 Birr)" data-minutes="20" data-price="500">Hand Reflexology – 20 min (500 Birr)</option>
                                        <option value="Hand Reflexology – 30 min (700 Birr)" data-minutes="30" data-price="700">Hand Reflexology – 30 min (700 Birr)</option>
                                    </optgroup>
                                    <option value="__CUSTOM__">✏️ Custom / Other (type custom details below)...</option>
                                </select>
                            </div>
                            <div class="col-md-5 col-12">
                                <label class="fw-bold mb-1 d-flex align-items-center gap-1 text-dark fs-6" for="cenacleCustomerNameInput">
                                    <i class="bi bi-person-fill text-primary"></i>
                                    <span>Customer Name</span>
                                </label>
                                <input type="text" id="cenacleCustomerNameInput" class="form-control form-control-md" placeholder="e.g. Abebe Kebede">
                            </div>
                        </div>

                        <!-- Custom Treatment field: shown when "Custom / Other" is selected -->
                        <div id="cenacleCustomTreatmentArea" class="mt-3 p-2 bg-light rounded border border-warning" style="display: none;">
                            <label class="fw-bold mb-1 text-dark d-flex align-items-center gap-1" for="cenacleCustomTreatmentText">
                                <i class="bi bi-pencil-square text-warning fs-5"></i>
                                <span>Write Custom Treatment Details / Special Instructions:</span>
                            </label>
                            <input type="text" id="cenacleCustomTreatmentText" class="form-control" placeholder="e.g. Foot + Shoulder Combo (Special 1,500 Birr)">
                        </div>
                    </div>
                </div>

                <!-- Hidden native title field kept in sync for Cenacle form submission -->
                <div class="reservationTitle col-12 border-bottom py-2" style="display:none;" id="cenacleNativeTitleWrapper">
                    <div class="form-group">
                        <label class="fw-bold mb-0" for="reservationTitle">{translate key="ReservationTitle"}
                            {if $TitleRequired}
                            <i class="bi bi-asterisk text-danger align-top text-small"></i>
                            {/if}
                        </label>
                        {textbox name="RESERVATION_TITLE" class="form-control has-feedback" value="ReservationTitle" id="reservationTitle" maxlength="300" required=$TitleRequired}
                    </div>
                </div>
                {assign var="detailsCol" value="col-12"}

                {if $ShowParticipation && $AllowParticipation && $ShowReservationDetails}
                {assign var="detailsCol" value="col-12 col-sm-6"}
                {/if}

                <div class="form-group {$detailsCol} py-2 border-bottom">
                    <label class="fw-bold" for="userName">{translate key='Owner'}</label>
                    {if $ShowUserDetails && $ShowReservationDetails}
                    <a href="#" id="userName" data-userid="{$UserId}" class="link-primary">{$ReservationUserName}</a>
                    {else}
                    {translate key=Private}
                    {/if}
                    <input id="userId" type="hidden" {formname key=USER_ID} value="{$UserId}" />
                    {if $CanChangeUser}
                    <a href="#" id="showChangeUsers" class="link-primary">{translate key=Change} <i
                            class="bi bi-person-fill"></i></a>
                    <div class="modal fade" id="changeUserDialog" tabindex="-1" role="dialog"
                        aria-labelledby="usersModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-scrollable">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="usersModalLabel">{translate key=ChangeUser}
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-hidden="true"></button>
                                </div>
                                <div class="modal-body">
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-outline-secondary"
                                        data-bs-dismiss="modal">{translate key='Cancel'}</button>
                                    <button type="button" class="btn btn-primary">{translate key='Done'}</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    {/if}
                    <div id="availableCredits" {if !$CreditsEnabled}class="d-none" {/if}>
                        {translate key=AvailableCredits}
                        <span id="availableCreditsCount" class="fw-bold">{$CurrentUserCredits}</span> |
                        {translate key=CreditsRequired}
                        <span id="requiredCreditsCount">
                            <span class="spinner-border spinner-border-sm" role="status"></span></span>
                        <span id="creditCost" class="fw-bold"></span>
                    </div>


                    <div class="mb-4" id="changeUsers" style="display: none;">
                        <div class="form-group d-flex align-items-center gap-1">
                            <label for="changeUserAutocomplete" class="visually-hidden">{translate key=User}</label>
                            <input type="text" id="changeUserAutocomplete"
                                class="form-control form-control-sm user-search" />
                            <span class="vr m-2"></span>
                            <a href="#" id="promptForChangeUsers" class="link-primary">
                                <i class="bi bi-people-fill"></i>
                                {translate key='AllUsers'}
                            </a>
                        </div>
                    </div>
                </div>

                <div class="form-group {$detailsCol} py-2 border-bottom">
                    {if $ShowParticipation && $AllowParticipation && $ShowReservationDetails}
                    {include file="Reservation/participation.tpl"}
                    {else}
                    {include file="Reservation/private-participation.tpl"}
                    {/if}
                </div>


                <div class="reservationDates col-12 py-2 border-bottom">
                    <div class="d-flex flex-wrap">
                        <div class="form-group d-flex align-items-center me-2">
                            <label for="BeginDate" class="reservationDate fw-bold">{translate key='BeginDate'}</label>
                            <input type="text" id="BeginDate"
                                class="form-control form-control-sm d-inline-block w-auto{if $LockPeriods} no-show{/if}"
                                {formname key=BEGIN_DATE} />
                            <select id="BeginPeriod" {formname key=BEGIN_PERIOD}
                                class="form-select form-select-sm w-auto timeinput{if $LockPeriods} no-show{/if}"
                                title="Begin time">
                                {foreach from=$StartPeriods item=period}
                                {if $period->IsReservable()}
                                {assign var='selected' value=''}
                                {if $period eq $SelectedStart}
                                {assign var='selected' value=' selected="selected"'}
                                {assign var='startPeriod' value=$period}
                                {/if}
                                <option value="{$period->Begin()}" {$selected}>{$period->Label()}</option>
                                {/if}
                                {/foreach}
                            </select>
                            {if $LockPeriods}{formatdate date=$StartDate} {$startPeriod->Label()}{/if}
                        </div>

                        <div class="form-group d-flex align-items-center">
                            <label for="EndDate"
                                class="reservationDate fw-bold text-md-end pe-md-1">{translate key='EndDate'}</label>
                            <input type="text" id="EndDate"
                                class="form-control form-control-sm d-inline-block w-auto{if $LockPeriods} no-show{/if}"
                                {formname key=END_DATE} />
                            <select id="EndPeriod" {formname key=END_PERIOD}
                                class="form-select form-select-sm w-auto timeinput{if $LockPeriods} no-show{/if}"
                                title="End time">
                                {foreach from=$EndPeriods item=period name=endPeriods}
                                {if $period->IsReservable()}
                                {assign var='selected' value=''}
                                {if $period eq $SelectedEnd}
                                {assign var='selected' value=' selected="selected"'}
                                {assign var='endPeriod' value=$period}
                                {/if}
                                <option value="{$period->End()}" {$selected}>{$period->LabelEnd()}</option>
                                {/if}
                                {/foreach}
                            </select>
                            {if $LockPeriods}{formatdate date=$EndDate} {$endPeriod->LabelEnd()}{/if}
                        </div>


                        <div class="reservationLength d-flex align-items-center ms-5">
                            <div class="form-group">
                                <span class="durationText fw-bold">
                                    <span id="durationDays">0</span> {translate key=days}
                                    <span id="durationHours">0</span> {translate key=hours}
                                    <span id="durationMinutes">0</span> {translate key=minutes}
                                </span>
                            </div>
                        </div>

                        {if $ShowParticipation && $AllowParticipation && $ShowReservationDetails}
                        <div class=" d-flex align-items-center ms-5">
                            <a href="#" id="btnViewAvailability" class="link-primary"><i class="bi bi-calendar3"></i>
                                {translate key="ViewAvailability"}</a>
                        </div>
                        {/if}
                    </div>

                    {if !$HideRecurrence}
                    <div class="pt-2">{$HideRecurrence}
                        {control type="RecurrenceControl" RepeatTerminationDate=$RepeatTerminationDate}
                    </div>
                    {/if}

                </div>

                <div class="reservationResources col-12 col-sm-6 py-2 border-bottom" id="reservation-resources">
                    <div class="d-flex align-items-center gap-2">
                        <label class="fw-bold mb-0">{translate key="Resources"}</label>
                        {if $ShowAdditionalResources}
                        <a id="btnAddResources" href="#" class="link-primary" data-bs-toggle="modal"
                            data-bs-target="#dialogResourceGroups">{translate key=Change} <span
                                class="bi bi-plus-square-fill"></span></a>
                        {/if}
                    </div>

                    <div class="d-inline-block">
                        <div id="primaryResourceContainer">
                            <input type="hidden" id="scheduleId" {formname key=SCHEDULE_ID} value="{$ScheduleId}" />
                            <input class="resourceId" type="hidden" id="primaryResourceId" {formname key=RESOURCE_ID}
                                value="{$ResourceId}" />
                            {displayResource resource=$Resource}
                        </div>

                        <div id="additionalResources">
                            {foreach from=$AvailableResources item=resource}
                            {if is_array($AdditionalResourceIds) && in_array($resource->Id, $AdditionalResourceIds)}
                            <input class="resourceId" type="hidden" name="{FormKeys::ADDITIONAL_RESOURCES}[]"
                                value="{$resource->Id}" />
                            {displayResource resource=$resource}
                            {/if}
                            {/foreach}
                        </div>
                    </div>
                </div>

                <div class="form-group col-12 col-sm-6 py-2 border-bottom">
                    <div class="accessoriesDiv">
                        {if $ShowReservationDetails && $AvailableAccessories|default:array()|count > 0}
                        <div class="d-flex align-items-center gap-2">
                            <label class="fw-bold mb-0" for="addAccessoriesPrompt">{translate key="Accessories"}</label>
                            <a href="#" id="addAccessoriesPrompt" class="link-primary" data-bs-toggle="modal"
                                data-bs-target="#dialogAddAccessories">{translate key='Add'} <span
                                    class="bi bi-plus-square-fill"></span></a>
                        </div>
                        <div id="accessories"></div>
                        {/if}
                    </div>
                </div>

                <div class="form-group col-12 py-2 border-bottom">
                    {if $ShowParticipation && $AllowParticipation && $ShowReservationDetails}
                    {include file="Reservation/invitees.tpl"}
                    {else}
                    {include file="Reservation/private-participation.tpl"}
                    {/if}
                </div>


                {if $RemindersEnabled}
                <div class="reservationReminders border-bottom py-2">
                    <label class="fw-bold mb-0">{translate key=SendReminder}</label>
                    <div class="d-flex gap-5">
                        <div id="reminderOptionsStart" class="d-flex align-items-center flex-wrap gap-1">
                            <div class="form-check">
                                <input type="checkbox" id="startReminderEnabled"
                                    class="reminderEnabled form-check-input" {formname key=START_REMINDER_ENABLED}
                                    aria-label="Enable Start Reminder Interval" />
                            </div>
                            <label for="startReminderTime" class="visually-hidden">Start Reminder Time</label>
                            <label for="startReminderInterval" class="visually-hidden">Start Reminder Interval</label>
                            <input type="number" min="0" max="999" size="3" maxlength="3" value="15"
                                class="reminderTime form-control form-control-sm w-auto"
                                {formname key=START_REMINDER_TIME} id="startReminderTime" />
                            <select class="reminderInterval form-select form-select-sm w-auto"
                                {formname key=START_REMINDER_INTERVAL} id="startReminderInterval">
                                <option value="{ReservationReminderInterval::Minutes}">{translate key=minutes}
                                </option>
                                <option value="{ReservationReminderInterval::Hours}">{translate key=hours}</option>
                                <option value="{ReservationReminderInterval::Days}">{translate key=days}</option>
                            </select>

                            <span class="reminderLabel">{translate key=ReminderBeforeStart}</span>
                        </div>
                        <div id="reminderOptionsEnd" class="d-flex align-items-center flex-wrap gap-1">
                            <div class="form-check">
                                <input type="checkbox" id="endReminderEnabled" class="reminderEnabled form-check-input"
                                    {formname key=END_REMINDER_ENABLED} aria-label="Enable End Reminder Interval" />
                            </div>
                            <label for="endReminderTime" class="visually-hidden">End Reminder Time</label>
                            <label for="endReminderInterval" class="visually-hidden">End Reminder Interval</label>
                            <input type="number" min="0" max="999" size="3" maxlength="3" value="15"
                                class="reminderTime form-control form-control-sm w-auto"
                                {formname key=END_REMINDER_TIME} id="endReminderTime" />
                            <select class="reminderInterval form-select form-select-sm w-auto"
                                {formname key=END_REMINDER_INTERVAL} id="endReminderInterval">
                                <option value="{ReservationReminderInterval::Minutes}">{translate key=minutes}
                                </option>
                                <option value="{ReservationReminderInterval::Hours}">{translate key=hours}</option>
                                <option value="{ReservationReminderInterval::Days}">{translate key=days}</option>
                            </select>
                            <span class="reminderLabel">{translate key=ReminderBeforeEnd}</span>

                        </div>
                    </div>
                </div>
                {/if}

                <div class="reservationDescription border-bottom py-2">
                    <div class="form-group">
                        <label class="fw-bold mb-0" for="description">
                            {translate key="ReservationDescription"}{if $DescriptionRequired}<i
                                class="bi bi-asterisk text-danger align-top text-small"></i>
                            {/if}
                        </label>
                        <textarea id="description" name="{FormKeys::DESCRIPTION}" class="form-control has-feedback"
                            {if $DescriptionRequired}required="required" {/if}>{$Description}</textarea>
                    </div>

                </div>
            </div>

            <div id="custom-attributes-placeholder"></div>

            {if $UploadsEnabled}
            <div class="border-bottom py-2">
                <div class="reservationAttachments">

                    <label class="fw-bold mb-0">{translate key=AttachFile} <span
                            class="note fst-italic">({$MaxUploadSize} MB {translate key=Maximum})</span>
                    </label>

                    <div id="reservationAttachments">
                        <div class="attachment-item">
                            <label class="fw-bold" for="reservationUploadFile">Reservation Upload File</label>
                            <input type="file" {formname key=RESERVATION_FILE multi=true} id="reservationUploadFile"
                                class="form-control form-control-sm w-auto" />
                            <a class="add-attachment link-primary" href="#">{translate key=Add}<i
                                    class="bi bi-plus-square-fill ms-1"></i></a>
                            <a class="remove-attachment link-primary" href="#"><span
                                    class="visually-hidden">{translate key=Delete}</span><i
                                    class="bi bi-dash-square-fill"></i></a>
                        </div>
                    </div>
                </div>
            </div>
            {/if}

            {if $Terms != null}
            <div class="py-2" id="termsAndConditions">
                <div class="">
                    {if $TermsAccepted}
                    <div class="">
                        <i class="bi bi-check-square-fill me-1"></i>{translate key=IAccept}
                        <a href="{$Terms->DisplayUrl()}" class="link-primary"
                            target="_blank">{translate key=TheTermsOfService}</a>
                    </div>
                    {else}
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="termsAndConditionsAcknowledgement"
                            {formname key=TOS_ACKNOWLEDGEMENT} {if $TermsAccepted}checked="checked" {/if} />
                        <label for="termsAndConditionsAcknowledgement">{translate key=IAccept}</label>
                        <a href="{$Terms->DisplayUrl()}" class="link-primary"
                            target="_blank">{translate key=TheTermsOfService}</a>
                    </div>
                    {/if}
                </div>
            </div>
            {/if}


            <input type="hidden" {formname key=RESERVATION_ID} value="{$ReservationId}" />
            <input type="hidden" {formname key=REFERENCE_NUMBER} value="{$ReferenceNumber}" id="referenceNumber" />
            <input type="hidden" {formname key=RESERVATION_ACTION} value="{$ReservationAction}" />
            <input type="hidden" {formname key=DELETE_REASON} value="" id="hdnDeleteReason" />

            <input type="hidden" {formname key=SERIES_UPDATE_SCOPE} id="hdnSeriesUpdateScope"
                value="{SeriesUpdateScope::FullSeries}" />

            <div class="">
                <div class="reservationButtons clearfix">
                    <div class="float-sm-end">
                        <button type="button" class="btn btn-sm btn-outline-secondary"
                            onclick="window.location='{$ReturnUrl}'">
                            <i class="bi bi-arrow-left-circle-fill"></i>
                            <span class="d-none d-sm-inline-block">{translate key='Cancel'}</span>
                        </button>
                        {block name="submitButtons"}
                        <button type="button" class="btn btn-sm btn-primary save create btnCreate">
                            <i class="bi bi-check-circle"></i>
                            {translate key='Create'} </button>
                        {/block}
                    </div>
                </div>
            </div>

            {csrf_token}

            {if $UploadsEnabled}
            {block name='attachments'}
            {/block}
            {/if}

            <div id="retrySubmitParams" class="d-none"></div>
        </form>
    </div>
</div>

<div class="modal fade" id="dialogResourceGroups" tabindex="-1" role="dialog" aria-labelledby="resourcesModalLabel"
    aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="resourcesModalLabel">{translate key=AddResources}</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-hidden="true"></button>
            </div>
            <div class="modal-body">
                <div id="resourceGroups"></div>
            </div>
            <div class="modal-footer">
                <div id="checking-availability" class="float-start">{translate key=CheckingAvailability} <div
                        class="spinner-border spinner-border-sm" role="status"></div>
                </div>
                <div id="checking-availability-error" class="float-start no-show">
                    {translate key=CheckingAvailabilityError}</div>
                <button type="button" class="btn btn-outline-secondary btnClearAddResources"
                    data-bs-dismiss="modal">{translate key='Cancel'}</button>
                <button type="button" class="btn btn-primary btnConfirmAddResources">{translate key='Done'}</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="dialogAddAccessories" tabindex="-1" role="dialog" aria-labelledby="accessoryModalLabel"
    aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="accessoryModalLabel">{translate key=AddAccessories}</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-hidden="true"></button>
            </div>
            <div class="modal-body">
                <table class="table table-sm">
                    <thead>
                        <tr>
                            <th>{translate key=Accessory}</th>
                            <th>{translate key=QuantityRequested}</th>
                            <th>{translate key=QuantityAvailable}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$AvailableAccessories item=accessory}
                        <tr accessory-id="{$accessory->GetId()}">
                            <td>{$accessory->GetName()}</td>
                            <td>
                                <input type="hidden" class="name" value="{$accessory->GetName()}" />
                                <input type="hidden" class="id" value="{$accessory->GetId()}" />
                                <input type="hidden" class="resource-ids"
                                    value="{$accessory->ResourceIds()|join:','}" />
                                <label for="accessory{$accessory->GetId()}"
                                    class="visually-hidden">{$accessory->GetName()}</label>
                                {if $accessory->GetQuantityAvailable() == 1}
                                <input class="form-check-input" type="checkbox" name="accessory{$accessory->GetId()}"
                                    id="accessory{$accessory->GetId()}" value="1" size="3" aria-label="checkbox" />
                                {else}
                                <input type="number" min="0" max="999"
                                    class="form-control form-control-sm accessory-quantity"
                                    name="accessory{$accessory->GetId()}" id="accessory{$accessory->GetId()}" value="0"
                                    size="3" />
                                {/if}
                            </td>
                            <td accessory-quantity-id="{$accessory->GetId()}"
                                accessory-quantity-available="{$accessory->GetQuantityAvailable()}">
                                {$accessory->GetQuantityAvailable()|default:'&infin;'}</td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>

            </div>
            <div class="modal-footer">
                {cancel_button}
                <button id="btnConfirmAddAccessories" type="button"
                    class="btn btn-primary">{translate key='Done'}</button>
            </div>
        </div>
    </div>
</div>


<div id="wait-box" class="modal fade" aria-labelledby="update-boxLabel" data-bs-backdrop="static" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-body">
                <div id="creatingNotification" class="text-center">
                    <h3 id="createUpdateMessage" class="d-none">
                        {block name="ajaxMessage"}
                        {translate key=CreatingReservation}
                        {/block}
                    </h3>
                    <h3 id="checkingInMessage" class="d-none">
                        {translate key=CheckingIn}
                    </h3>
                    <h3 id="checkingOutMessage" class="d-none">
                        {translate key=CheckingOut}
                    </h3>
                    <h3 id="joiningWaitingList" class="d-none">
                        {translate key=AddingToWaitlist}
                    </h3>
                    <div class="spinner-border text-secondary" style="width: 3rem; height: 3rem;" role="status"></div>
                </div>
                <div id="result" class="text-center"></div>
            </div>
        </div>
    </div>
</div>

<div id="user-availability-box"></div>

</div>

{block name=extras}{/block}

{include file="javascript-includes.tpl"}

{control type="DatePickerSetupControl" ControlId="BeginDate" DefaultDate=$StartDate MinDate=$AvailabilityStart MaxDate=$AvailabilityEnd FirstDay=$FirstWeekday}
{control type="DatePickerSetupControl" ControlId="EndDate" DefaultDate=$EndDate MinDate=$AvailabilityStart MaxDate=$AvailabilityEnd FirstDay=$FirstWeekday}
{control type="DatePickerSetupControl" ControlId="EndRepeat" DefaultDate=$RepeatTerminationDate MinDate=$StartDate MaxDate=$AvailabilityEnd FirstDay=$FirstWeekday}
{control type="DatePickerSetupControl" ControlId="RepeatDate" MaxDate=$AvailabilityEnd FirstDay=$FirstWeekday MinDate=Date::Now()->ToTimezone($Timezone) Multiple=false}

{jsfile src="resourcePopup.js"}
{jsfile src="userPopup.js"}
{jsfile src="date-helper.js"}
{jsfile src="recurrence.js"}
{jsfile src="reservation.js"}
{jsfile src="autocomplete.js"}
{jsfile src="force-numeric.js"}
{jsfile src="reservation-reminder.js"}
{jsfile src="ajax-helpers.js"}
{jsfile src="reservation-pdf.js"}
{vendor_js src="jqtree/1.8.11/js/tree.jquery.js"}

{include file="Reservation/pdf_libraries.tpl"}
{include file="Reservation/pdf.tpl"}
<script type="text/javascript">
    $(function() {
        var scopeOptions = {
            instance: '{SeriesUpdateScope::ThisInstance}',
            full: '{SeriesUpdateScope::FullSeries}',
            future: '{SeriesUpdateScope::FutureInstances}'
        };

        var reservationOpts = {
            additionalResourceElementId: '{FormKeys::ADDITIONAL_RESOURCES}',
            accessoryListInputId: '{FormKeys::ACCESSORY_LIST}[]',
            returnUrl: '{$ReturnUrl}',
            scopeOpts: scopeOptions,
            createUrl: 'ajax/reservation_save.php',
            updateUrl: 'ajax/reservation_update.php',
            deleteUrl: 'ajax/reservation_delete.php',
            checkinUrl: 'ajax/reservation_checkin.php?action={ReservationAction::Checkin}',
            checkoutUrl: 'ajax/reservation_checkin.php?action={ReservationAction::Checkout}',
            waitlistUrl: 'ajax/reservation_waitlist.php',
            userAutocompleteUrl: "ajax/autocomplete.php?type={AutoCompleteType::User}",
            groupAutocompleteUrl: "ajax/autocomplete.php?type={AutoCompleteType::Group}",
            changeUserAutocompleteUrl: "ajax/autocomplete.php?type={AutoCompleteType::MyUsers}",
            maxConcurrentUploads: '{$MaxUploadCount}',
            guestLabel: '({translate key=Guest})',
            accessoriesUrl: 'ajax/available_accessories.php?{QueryStringKeys::START_DATE}=[sd]&{QueryStringKeys::END_DATE}=[ed]&{QueryStringKeys::START_TIME}=[st]&{QueryStringKeys::END_TIME}=[et]&{QueryStringKeys::REFERENCE_NUMBER}=[rn]',
            resourcesUrl: 'ajax/unavailable_resources.php?{QueryStringKeys::SCHEDULE_ID}={$ScheduleId}&{QueryStringKeys::START_DATE}=[sd]&{QueryStringKeys::END_DATE}=[ed]&{QueryStringKeys::START_TIME}=[st]&{QueryStringKeys::END_TIME}=[et]&{QueryStringKeys::REFERENCE_NUMBER}=[rn]',
            creditsUrl: 'ajax/reservation_credits.php',
            creditsEnabled: '{$CreditsEnabled}',
            emailUrl: 'ajax/reservation_email.php?{QueryStringKeys::REFERENCE_NUMBER}={$ReferenceNumber}',
            availabilityUrl: 'ajax/availability.php?{QueryStringKeys::SCHEDULE_ID}={$ScheduleId}',
            maximumResources: {$MaximumResources|default:0}
        };

        var reminderOpts = {
            reminderTimeStart: '{$ReminderTimeStart}',
            reminderTimeEnd: '{$ReminderTimeEnd}',
            reminderIntervalStart: '{$ReminderIntervalStart}',
            reminderIntervalEnd: '{$ReminderIntervalEnd}'
        };

        var reservation = new Reservation(reservationOpts);
        reservation.init('{$UserId}', '{format_date date=$StartDate key=system_datetime timezone=$Timezone}', '{format_date date=$EndDate key=system_datetime timezone=$Timezone}');

        var reminders = new Reminder(reminderOpts);
        reminders.init();

        {foreach from=$Participants item=user}
        reservation.addParticipant("{$user->FullName|escape:'javascript'}", "{$user->UserId|escape:'javascript'}");
        {/foreach}

        {foreach from=$Invitees item=user}
        reservation.addInvitee("{$user->FullName|escape:'javascript'}", '{$user->UserId}');
        {/foreach}

        {foreach from=$ParticipatingGuests item=guest}
        reservation.addParticipatingGuest('{$guest}');
        {/foreach}

        {foreach from=$InvitedGuests item=guest}
        reservation.addInvitedGuest('{$guest}');
        {/foreach}

        {foreach from=$Accessories item=accessory}
        reservation.addAccessory({$accessory->AccessoryId}, {$accessory->QuantityReserved}, "{$accessory->Name|escape:'javascript'}");
        {/foreach}

        reservation.addResourceGroups({$ResourceGroupsAsJson});

        var recurOpts = {
            repeatType: '{$RepeatType}',
            repeatInterval: '{$RepeatInterval}',
            repeatMonthlyType: '{$RepeatMonthlyType}',
            repeatWeekdays: [{foreach from=$RepeatWeekdays item=day}{$day}, {/foreach}],
            autoSetTerminationDate: $('#referenceNumber').val() != '',
            customRepeatExclusions: ['{formatdate date=$StartDate key=system}']
        };

        var recurrence = new Recurrence(recurOpts);
        recurrence.init();

        recurrence.onChange(reservation.repeatOptionsChanged);

        {foreach from=$CustomRepeatDates item=date}
        recurrence.addCustomDate('{format_date date=$date key=system timezone=$Timezone}',
        '{format_date date=$date key=schedule_daily timezone=$Timezone}');
        {/foreach}

        var ajaxOptions = {
            target: '#result', // target element(s) to be updated with server response
            beforeSubmit: reservation.preSubmit, // pre-submit callback
            success: reservation.showResponse // post-submit callback
        };

        $('#form-reservation').submit(function() {
            $(this).ajaxSubmit(ajaxOptions);
            return false;
        });

        $('#userName').bindUserDetails();

        translateTooltips();

    });
    $('.modal').on('shown.bs.modal', function() {
        $(this).find('[autofocus]').focus();
    });
</script>

<script>
    function translateTooltips() {
        var resourcesContainer = document.querySelector('#reservation-resources');
        var resources = [].slice.call(resourcesContainer.querySelectorAll('[data-bs-toggle="tooltip"]'));
        resources.forEach(function(resource) {
            var tooltipType = resource.getAttribute('data-bs-title');
            if (tooltipType === 'approval') {
                var tooltipText = "{translate key=RequiresApproval}";
            }
            if (tooltipType === 'checkin') {
                var tooltipText ="{translate key=RequiresCheckInNotification}";
            }
            if (tooltipType === 'autorelease') {
                var text = "{translate key=AutoReleaseNotification args='%s'}";
                    var tooltipText = text.replace('%s', resource.getAttribute('data-autorelease'));
                }
                resource.setAttribute('data-bs-title', tooltipText);
                new bootstrap.Tooltip(resource);
            });
        }
    </script>

{literal}
<script type="text/javascript">
$(document).ready(function() {
    function norm(str) {
        return (str || '').toLowerCase()
            .replace(/&amp;/g, '&')
            .replace(/[\u2013\u2014\u2212\-]/g, '-')
            .replace(/\s+/g, ' ')
            .trim();
    }

    const treatmentSelect = $('#cenacleTreatmentSelect');
    const customerInput   = $('#cenacleCustomerNameInput');
    const customArea      = $('#cenacleCustomTreatmentArea');
    const customText      = $('#cenacleCustomTreatmentText');
    const nativeTitle     = $('#reservationTitle');

    // ── Helper: Synchronize Title & Custom Attributes ──────────────
    function syncCenacleTitle() {
        const selectedVal = treatmentSelect.val();
        const custName    = (customerInput.val() || '').trim();
        let treatDisplay  = '';

        if (selectedVal === '__CUSTOM__') {
            treatDisplay = (customText.val() || '').trim();
        } else if (selectedVal) {
            treatDisplay = selectedVal;
        }

        // Build Title
        let finalTitle = '';
        if (custName && treatDisplay) {
            finalTitle = custName + ' – ' + treatDisplay;
        } else if (custName) {
            finalTitle = custName;
        } else if (treatDisplay) {
            finalTitle = treatDisplay;
        }

        nativeTitle.val(finalTitle);

        // Sync to custom attributes dropdown if present
        const customAttrSelect = $('#custom-attributes-placeholder select');
        if (customAttrSelect.length > 0 && selectedVal && selectedVal !== '__CUSTOM__') {
            const targetNorm = norm(selectedVal);
            customAttrSelect.find('option').each(function() {
                if (norm($(this).val()) === targetNorm || norm($(this).text()) === targetNorm) {
                    customAttrSelect.val($(this).val()).trigger('change');
                    return false;
                }
            });
        }
    }

    // ── Dropdown Change Event ───────────────────────────────────────
    treatmentSelect.on('change', function() {
        const val = $(this).val();
        if (val === '__CUSTOM__') {
            customArea.slideDown(200);
            customText.focus();
        } else {
            customArea.slideUp(150);
        }

        // Auto-adjust end time if minutes data attribute is available
        const selectedOpt = $(this).find('option:selected');
        const minutes = parseInt(selectedOpt.attr('data-minutes') || '0', 10);
        if (minutes > 0) {
            try {
                const beginPeriod = $('#BeginPeriod').val();
                if (beginPeriod) {
                    // Try to calculate matching EndPeriod
                    const parts = beginPeriod.split(':');
                    if (parts.length >= 2) {
                        const totalMins = parseInt(parts[0], 10) * 60 + parseInt(parts[1], 10) + minutes;
                        const endH = Math.floor(totalMins / 60) % 24;
                        const endM = totalMins % 60;
                        function p2(n) { return (n < 10 ? '0' : '') + n; }
                        const targetEndPrefix = p2(endH) + ':' + p2(endM);
                        $('#EndPeriod option').each(function() {
                            if ($(this).val().indexOf(targetEndPrefix) === 0 || $(this).text().indexOf(targetEndPrefix) !== -1) {
                                $('#EndPeriod').val($(this).val()).trigger('change');
                                return false;
                            }
                        });
                    }
                }
            } catch(e) {}
        }

        syncCenacleTitle();
    });

    customerInput.on('input keyup change', syncCenacleTitle);
    customText.on('input keyup change', syncCenacleTitle);

    // ── Check if opened via Drag-and-Drop Intake ────────────────────
    const rawPayload = sessionStorage.getItem('cenacle_intake_payload');
    let payload = null;
    if (rawPayload) {
        try { payload = JSON.parse(rawPayload); } catch(e) {}
    }

    if (payload) {
        // Pre-fill Customer Name & Treatment
        if (payload.customerName) {
            customerInput.val(payload.customerName);
        }
        if (payload.resourceId) {
            const resInput = $('#primaryResourceId');
            if (resInput.length && (!resInput.val() || resInput.val() === '0')) {
                resInput.val(payload.resourceId);
            }
        }

        const targetTreatment = payload.dropdownValue || payload.treatment;
        let matchedInSelect = false;
        if (targetTreatment) {
            const targetNorm = norm(targetTreatment);
            treatmentSelect.find('option').each(function() {
                if (norm($(this).val()) === targetNorm || norm($(this).text()) === targetNorm) {
                    treatmentSelect.val($(this).val());
                    matchedInSelect = true;
                    return false;
                }
            });
            if (!matchedInSelect) {
                // If custom treatment
                treatmentSelect.val('__CUSTOM__');
                customArea.show();
                customText.val(targetTreatment);
            }
        }

        syncCenacleTitle();

        // Show banner
        const bannerHtml = `
            <div id="cenacle-intake-banner" class="alert alert-success d-flex align-items-center justify-content-between p-3 my-2 rounded shadow-sm" style="border-left: 5px solid #2C6E6E; background-color: #f0fdf4;">
                <div>
                    <div class="fw-bold text-success fs-6"><i class="bi bi-magic me-1"></i> Quick Intake Pre-filled from Drag &amp; Drop:</div>
                    <div class="text-dark mt-1">
                        Customer: <strong>${payload.customerName}</strong> • Treatment: <strong>${payload.dropdownValue || payload.treatment}</strong>
                        ${payload.phone ? ` • Phone: <strong>${payload.phone}</strong>` : ''}
                        • Persons: <strong>${payload.persons}</strong>
                    </div>
                    <div class="small text-muted mt-1" id="cenacle-intake-status-msg">
                        <i class="bi bi-shield-check text-success me-1"></i> Zero Double-Booking: 5-minute cleaning buffer held automatically after this reservation.
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        `;
        $('.reservationHeader').after(bannerHtml);
    } else {
        // Direct new reservation or editing: check if existing title matches a treatment
        const currentTitle = nativeTitle.val();
        if (currentTitle) {
            let matched = false;
            const titleNorm = norm(currentTitle);
            treatmentSelect.find('option').each(function() {
                if ($(this).val() && $(this).val() !== '__CUSTOM__' && titleNorm.indexOf(norm($(this).val())) !== -1) {
                    treatmentSelect.val($(this).val());
                    matched = true;
                    return false;
                }
            });
            if (!matched) {
                customerInput.val(currentTitle);
            }
        }
    }

    // ── Poll for custom attributes to load via AJAX ─────────────────
    let attempts = 0;
    const maxAttempts = 60; // 6 seconds
    const pollInterval = setInterval(function() {
        attempts++;
        const customAttrContainer = $('#custom-attributes-placeholder');
        const customSelect = customAttrContainer.find('select');

        if (customSelect.length > 0 || attempts >= maxAttempts) {
            clearInterval(pollInterval);
            sessionStorage.removeItem('cenacle_intake_payload');

            if (customSelect.length > 0) {
                // If treatment is already selected in top dropdown, apply it to customSelect
                const topVal = treatmentSelect.val();
                if (topVal && topVal !== '__CUSTOM__') {
                    const topNorm = norm(topVal);
                    customSelect.find('option').each(function() {
                        if (norm($(this).val()) === topNorm || norm($(this).text()) === topNorm) {
                            customSelect.val($(this).val()).trigger('change');
                            return false;
                        }
                    });
                }

                // If user changes customSelect, sync back to top dropdown
                customSelect.on('change', function() {
                    const v = $(this).val();
                    if (v) {
                        const cNorm = norm(v);
                        treatmentSelect.find('option').each(function() {
                            if (norm($(this).val()) === cNorm) {
                                treatmentSelect.val($(this).val());
                                customArea.hide();
                                syncCenacleTitle();
                                return false;
                            }
                        });
                    }
                });

                if (payload) {
                    // Match Persons
                    const personsInput = customAttrContainer.find('#psiattribute2, input[name*="psiattribute[2]"]');
                    if (personsInput.length) {
                        personsInput.val(payload.persons || '1').trigger('change');
                    } else {
                        customAttrContainer.find('input[type="text"]').each(function() {
                            const label = $(this).closest('.form-group, .customAttribute').find('label').text().toLowerCase();
                            if (label.indexOf('person') !== -1) {
                                $(this).val(payload.persons || '1').trigger('change');
                            }
                        });
                    }

                    // Match Phone Number
                    const phoneInput = customAttrContainer.find('#psiattribute3, input[name*="psiattribute[3]"]');
                    if (phoneInput.length) {
                        phoneInput.val(payload.phone || '').trigger('change');
                    } else {
                        customAttrContainer.find('input[type="text"]').each(function() {
                            const label = $(this).closest('.form-group, .customAttribute').find('label').text().toLowerCase();
                            if (label.indexOf('phone') !== -1) {
                                $(this).val(payload.phone || '').trigger('change');
                            }
                        });
                    }

                    // Match Notes
                    const notesInput = customAttrContainer.find('#psiattribute4, textarea[name*="psiattribute[4]"]');
                    if (notesInput.length) {
                        notesInput.val(payload.notes || '').trigger('change');
                    } else {
                        customAttrContainer.find('textarea').each(function() {
                            const label = $(this).closest('.form-group, .customAttribute').find('label').text().toLowerCase();
                            if (label.indexOf('note') !== -1) {
                                $(this).val(payload.notes || '').trigger('change');
                            }
                        });
                    }

                    // Auto-submit if requested
                    if (payload.autoSubmit) {
                        $('#cenacle-intake-status-msg').html('<span class="spinner-border spinner-border-sm text-success me-1"></span> Finalizing and creating reservation...');
                        setTimeout(function() {
                            $('.btnCreate, .btn-primary.save.create').first().click();
                        }, 400);
                    }
                }
            }
        }
    }, 100);
});
</script>
{/literal}

    {include file='globalfooter.tpl'}
