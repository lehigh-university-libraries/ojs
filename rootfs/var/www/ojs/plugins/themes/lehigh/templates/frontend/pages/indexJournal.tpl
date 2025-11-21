{**
 * templates/frontend/pages/indexJournal.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display the index page for a journal - Bootstrap 5 styled for Lehigh theme
 *
 * @uses $currentJournal Journal This journal
 * @uses $journalDescription string Journal description from HTML text editor
 * @uses $homepageImage object Image to be displayed on the homepage
 * @uses $additionalHomeContent string Arbitrary input from HTML text editor
 * @uses $announcements array List of announcements
 * @uses $numAnnouncementsHomepage int Number of announcements to display on the
 *       homepage
 * @uses $issue Issue Current issue
 *
 * @hook Templates::Index::journal []
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}

<div class="page_index_journal">
	<div class="container py-4">
		{call_hook name="Templates::Index::journal"}

		{if $highlights->count()}
			<div class="mb-4">
				{include file="frontend/components/highlights.tpl" highlights=$highlights}
			</div>
		{/if}

		{if $activeTheme && !$activeTheme->getOption('useHomepageImageAsHeader') && $homepageImage}
			<div class="homepage_image mb-4">
				<img
					src="{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}"
					{if $homepageImage.altText}alt="{$homepageImage.altText|escape}"{/if}
					class="img-fluid rounded shadow-sm"
				>
			</div>
		{/if}

		{* Journal Description *}
		{if $activeTheme && $activeTheme->getOption('showDescriptionInJournalIndex')}
			<section class="homepage_about mb-5">
				<a id="homepageAbout"></a>
				<div class="card shadow-sm">
					<div class="card-body p-4">
						<h2 class="h3 mb-3">{translate key="about.aboutContext"}</h2>
						{$currentContext->getLocalizedData('description')}
					</div>
				</div>
			</section>
		{/if}

		<div class="mb-4">
			{include file="frontend/objects/announcements_list.tpl" numAnnouncements=$numAnnouncementsHomepage}
		</div>

		{* Latest issue *}
		{if $issue}
			<section class="current_issue mb-5">
				<a id="homepageIssue"></a>
					<div class="col-12 card">
						<div class="card-header">
							<h1 class="mb-0">
								{translate key="journal.currentIssue"}: {$issue->getIssueIdentification()|escape}
						  </h1>
						</div>
						<div class="issue-toc card-body">
							{include file="frontend/objects/issue_toc.tpl"}
						</div>
					</div>

				<a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}" class="lehigh-btn lehigh-btn-primary mt-3">
					{translate key="journal.viewAllIssues"}
				</a>
			</section>
		{/if}

		{* Additional Homepage Content *}
		{if $additionalHomeContent}
			<div class="additional_content card shadow-sm">
				<div class="card-body p-4">
					{$additionalHomeContent}
				</div>
			</div>
		{/if}
	</div><!-- .container -->
</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
