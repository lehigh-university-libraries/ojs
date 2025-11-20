{**
 * templates/frontend/objects/issue_summary.tpl
 *
 * @brief Display a summary view of an issue
 *}

<div class="card h-100 shadow-sm hover-shadow transition">
	<div class="card-body d-flex flex-column">
		{if $issue->getLocalizedCoverImageUrl()}
			<div class="text-center mb-3">
				<img
					src="{$issue->getLocalizedCoverImageUrl()|escape}"
					alt="{$issue->getLocalizedCoverImageAltText()|escape|default:''}"
					class="img-fluid rounded"
					style="max-height: 200px; object-fit: cover; width: 100%;"
				>
			</div>
		{/if}

		<h3 class="card-title h5 mb-2">
			<a href="{url op="view" path=$issue->getBestIssueId()}" class="text-decoration-none text-dark stretched-link">
				{$issue->getIssueIdentification()|escape}
			</a>
		</h3>

		{if $issue->hasDescription()}
			<div class="card-text text-muted small mb-3 flex-grow-1">
				{$issue->getLocalizedDescription()|strip_unsafe_html|truncate:150}
			</div>
		{/if}

		{if $issue->getDatePublished()}
			<div class="text-muted small">
				<i class="bi bi-calendar3"></i>
				{$issue->getDatePublished()|date_format:$dateFormatShort}
			</div>
		{/if}
	</div>
</div>

<style>
	.hover-shadow {
		transition: all 0.3s ease;
	}
	.hover-shadow:hover {
		transform: translateY(-5px);
		box-shadow: 0 .5rem 1rem rgba(0,0,0,.15)!important;
	}
	.card .stretched-link:hover {
		color: var(--bs-primary, #0d6efd) !important;
	}
</style>
