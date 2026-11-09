<div>
	<div id="reservation-response-image">
		<i class="bi bi-exclamation-triangle-fill fs-1 text-danger"></i>
	</div>

	<div id="failed-message" class="reservation-message fw-bold fs-4">{translate key=ReservationCriticalError}</div>
	{if isset($ErrorMessageDetail)}
	<div class="alert alert-danger my-3 small text-start"><strong>Error details:</strong> {$ErrorMessageDetail}</div>
	{/if}

	<button id="btnSaveFailed" class="btn btn-warning text-white"><i
			class="bi bi-arrow-left-circle-fill me-1"></i>{translate key='ReservationErrors'}</button>
</div>