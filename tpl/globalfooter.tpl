	</div><!-- close main-->
	<div id="button-up" class="bg-primary rounded-circle text-white">
		<i class="bi bi-chevron-double-up" aria-hidden="true"></i>
	</div>
	<footer class="bg-light border-top text-center py-1" role="contentinfo">
		<div class="d-flex flex-wrap justify-content-center align-items-center gap-3 py-1" style="font-size:0.75rem;color:#6b7c7c;">
			<span style="font-weight:600;color:var(--cenacle-primary,#2C6E6E);letter-spacing:0.05em;">CENACLE REFLEXOLOGY</span>
			{* Colour legend row in footer for small screens *}
			<span class="d-flex gap-2 align-items-center">
				<span style="display:inline-block;width:8px;height:8px;border-radius:2px;background:#4A90D9;"></span> Foot Reflexology
				<span style="display:inline-block;width:8px;height:8px;border-radius:2px;background:#8B5CF6;"></span> Full Body
				<span style="display:inline-block;width:8px;height:8px;border-radius:2px;background:#B07DB0;"></span> Back Massage
				<span style="display:inline-block;width:8px;height:8px;border-radius:2px;background:#5FAD8E;"></span> Head &amp; Shoulder
				<span style="display:inline-block;width:8px;height:8px;border-radius:2px;background:#E8865A;"></span> Hand Reflexology
			</span>
			<a class="link-secondary" href="https://github.com/LibreBooking/librebooking" style="font-size:0.65rem;opacity:0.5;">Powered by LibreBooking</a>
		</div>
	</footer>

	<div class="toast-container position-fixed bottom-0 end-0 p-3">
		<div id="clipboardCopyToast" class="toast align-items-center bg-primary text-white border-0 d-none" role="alert"
			aria-live="assertive" aria-atomic="true">
			<div class="d-flex">
				<div class="toast-body">
					<i class="bi bi-check-circle-fill me-2"></i>{translate key=UrlCopiedToClipboard}
				</div>
				<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"
					aria-label="{translate key=Close}"></button>
			</div>
		</div>
		<div id="defaultSetToast" class="toast align-items-center bg-primary text-white border-0 d-none" role="alert"
			aria-live="assertive" aria-atomic="true">
			<div class="d-flex">
				<div class="toast-body">
					<i class="bi bi-check-circle-fill me-2"></i>{translate key=DefaultScheduleSet}
				</div>
				<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"
					aria-label="{translate key=Close}"></button>
			</div>
		</div>
	</div>

	<script type="text/javascript">
		init();

		{if isset($LoggedIn) && $LoggedIn && count($AvailableLanguages) > 1}
			$('#languageDropdownMenu').on('click', 'a[data-lang-code]', function(e) {
				e.preventDefault();
				var langCode = $(this).data('lang-code');
				var csrfToken = '{$CSRFToken|escape:'javascript'}';
				$.post('{$Path|escape:'javascript'}ajax/change_language.php', {
					'{FormKeys::LANGUAGE}': langCode,
					'{FormKeys::CSRF_TOKEN}': csrfToken
				}, 'json').done(function(data) {
					if (data && data.success) {
						window.location.reload();
					} else {
						console.error('Language change failed', data);
					}
				}).fail(function(jqXHR, textStatus, errorThrown) {
					console.error('Language change request failed', textStatus, errorThrown);
				});
			});
		{/if}
	</script>

	{if !empty($GoogleAnalyticsTrackingId)}
		<!-- Google tag (gtag.js) - Google Analytics -->
		<script async src="https://www.googletagmanager.com/gtag/js?id={$GoogleAnalyticsTrackingId}"></script>
		{literal}
			<script>
				window.dataLayer = window.dataLayer || [];
				function gtag(){dataLayer.push(arguments);}
				gtag('js', new Date());
			{/literal}
			gtag('config', '{$GoogleAnalyticsTrackingId}');
		</script>
	{/if}

	</body>

</html>
