{**
 * templates/frontend/pages/issue.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display a landing page for a single issue. It will show the table of contents
 *  (toc) or a cover image, with a click through to the toc.
 *
 * @uses $issue Issue The issue
 * @uses $issueIdentification string Label for this issue, consisting of one or
 *       more of the volume, number, year and title, depending on settings
 * @uses $issueGalleys array Galleys for the entire issue
 * @uses $primaryGenreIds array List of file genre IDs for primary types
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$issueIdentification}

<div class="page page_issue">
	<div class="container-fluid">
		{* Display a message if no current issue exists *}
		{if !$issue}
			{include file="frontend/components/breadcrumbs_issue.tpl" currentTitleKey="current.noCurrentIssue"}
			<div class="alert alert-warning shadow-sm rounded mb-4" role="alert">
				<h1 class="alert-heading h3 mb-3">
					{translate key="current.noCurrentIssue"}
				</h1>
				{include file="frontend/components/notification.tpl" type="warning" messageKey="current.noCurrentIssueDesc"}
			</div>

		{* Display an issue with the Table of Contents *}
		{else}
			{include file="frontend/components/breadcrumbs_issue.tpl" currentTitle=$issueIdentification}
			<div class="bg-white shadow-sm rounded p-4">
				<div class="row">
					<div class="col-12">
						<div class="issue-header mb-4">
							<h1 class="display-6 text-primary mb-0">
								{$issueIdentification|escape}
							</h1>
						</div>
					</div>
					<div class="col-12">
						<div class="issue-toc">
							{include file="frontend/objects/issue_toc.tpl"}
						</div>
					</div>
				</div>
			</div>
		{/if}
	</div>
</div>

{include file="frontend/components/footer.tpl"}
