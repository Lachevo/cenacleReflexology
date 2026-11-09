{include file='globalheader.tpl'}
<div class="error text-center my-4">
    <h3 class="text-danger mb-3">{translate key=$ErrorMessage}</h3>
    <h5 class="mt-3">
        <a class="btn btn-outline-secondary btn-sm"
            href="//{$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}">{translate key='ReturnToPreviousPage'}</a>
    </h5>
</div>

{include file="javascript-includes.tpl"}
{include file='globalfooter.tpl'}