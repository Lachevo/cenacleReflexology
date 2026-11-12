{include file='globalheader.tpl'}

<div id="page-maintenance">
    <div class="col-md-6 col-12 mx-auto mt-5">
        <div class="card shadow mb-2">
            <div class="card-body mx-3">
                <div id="maintenance-box" class="default-box">
                    <div class="maintenance-icon my-3 text-center">
                        {if $LogoUrl neq 'img/logo.png' && $LogoUrl neq 'img/librebooking.png' && $LogoUrl neq ''}
                            <img src="{$Path}{$LogoUrl}?{$Version}" alt="{$Title}" class="mx-auto d-block w-50">
                        {else}
                            <div class="cenacle-login-logo py-2">
                                <div style="font-size:1.85rem;font-weight:700;color:var(--cenacle-primary,#2C6E6E);letter-spacing:0.06em;">CENACLE</div>
                                <div style="font-size:0.8rem;color:#6b7c7c;letter-spacing:0.18em;font-weight:600;text-transform:uppercase;">REFLEXOLOGY</div>
                            </div>
                        {/if}
                    </div>
                    <div class="text-center mb-2">
                        <i class="bi bi-tools fs-1"></i>
                        <h2 class="fw-bold mb-3">{translate key='MaintenanceNotice'}</h2>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
{include file="javascript-includes.tpl"}
{include file='globalfooter.tpl'}