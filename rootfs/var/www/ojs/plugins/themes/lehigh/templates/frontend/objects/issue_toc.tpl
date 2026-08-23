{**
 * templates/frontend/objects/issue_toc.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief View of an Issue which displays a full table of contents.
 *
 * @uses $issue Issue The issue
 * @uses $issueTitle string Title of the issue. May be empty
 * @uses $issueSeries string Vol/No/Year string for the issue
 * @uses $issueGalleys array Galleys for the entire issue
 * @uses $hasAccess bool Can this user access galleys for this context?
 * @uses $publishedSubmissions array Lists of articles published in this issue
 *   sorted by section.
 * @uses $primaryGenreIds array List of file genre ids for primary file types
 * @uses $heading string HTML heading element, default: h2
 *}
{if !$heading}
	{assign var="heading" value="h2"}
{/if}
{assign var="articleHeading" value="h3"}
{if $heading == "h3"}
	{assign var="articleHeading" value="h4"}
{elseif $heading == "h4"}
	{assign var="articleHeading" value="h5"}
{elseif $heading == "h5"}
	{assign var="articleHeading" value="h6"}
{/if}
<div class="obj_issue_toc">

	{* Indicate if this is only a preview *}
	{if !$issue->getPublished()}
		<div class="alert alert-warning mb-4" role="alert">
			{include file="frontend/components/notification.tpl" type="warning" messageKey="editor.issues.preview"}
		</div>
	{/if}

	{* Issue introduction area above articles *}
	<div class="row g-4 mb-4">

		{* Issue cover image *}
		{assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}
		{if $issueCover}
			<div class="col-md-4 col-lg-3">
				<div class="card shadow-sm">
					<div class="card-body p-0">
						{capture assign="defaultAltText"}
							{translate key="issue.viewIssueIdentification" identification=$issue->getIssueIdentification()|escape}
						{/capture}
						<img src="{$issueCover|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:$defaultAltText}" class="img-fluid w-100 rounded">
					</div>
				</div>
			</div>
		{/if}

		<div class="{if $issueCover}col-md-8 col-lg-9{else}col-12{/if}">
			{* Description *}
			{if $issue->hasDescription()}
				<div class="border-bottom py-3">
					<span class="label text-primary mb-3">Description</h2>
					{$issue->getLocalizedDescription()|strip_unsafe_html}
				</div>
			{/if}

			{* PUb IDs (eg - URN) *}
			{foreach from=$pubIdPlugins item=pubIdPlugin}
				{assign var=pubId value=$issue->getStoredPubId($pubIdPlugin->getPubIdType())}
				{if $pubId}
					{assign var="resolvingUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
					<div class="border-bottom py-3">
						<span class="label mb-2">
							{$pubIdPlugin->getPubIdDisplayType()|escape}
						</span>
						<div class="text-break">
							{if $resolvingUrl}
								<a href="{$resolvingUrl|escape}">
									{$resolvingUrl}
								</a>
							{else}
								{$pubId}
							{/if}
						</div>
					</div>
				{/if}
			{/foreach}

			{* DOI *}
			{assign var=doiObject value=$issue->getData('doiObject')}
			{if $doiObject}
				{assign var="doiUrl" value=$doiObject->getData('resolvingUrl')|escape}
				<div class="border-bottom py-3">
					<span class="label mb-2">DOI</span>
					<div class="text-break">
						<a href="{$doiUrl|escape}">
							{$doiUrl}
						</a>
					</div>
				</div>
			{/if}

			{* Published date *}
			{if $includeIssuePublishDate && $issue->getDatePublished()}
				<div class="py-3">
					<span class="label mb-2">
						{translate key="submissions.published"}
					</span>
					<p>
						{$issue->getDatePublished()|date_format:$dateFormatShort}
					</p>
				</div>
			{/if}
		</div>
	</div>

	{* Full-issue galleys *}
	{if $issueGalleys}
		<div class="card shadow-sm mb-4">
			<div class="card-header bg-primary text-white">
				<{$heading} id="issueTocGalleyLabel" class="h5 mb-0">
					{translate key="issue.fullIssue"}
				</{$heading}>
			</div>
			<div class="card-body">
				<div class="d-flex flex-wrap gap-2">
					{foreach from=$issueGalleys item=galley}
						{include file="frontend/objects/galley_link.tpl" parent=$issue labelledBy="issueTocGalleyLabel" purchaseFee=$currentJournal->getData('purchaseIssueFee') purchaseCurrency=$currentJournal->getData('currency')}
					{/foreach}
				</div>
			</div>
		</div>
	{/if}

	{* Articles *}
	<div class="sections">
	{foreach name=sections from=$publishedSubmissions item=section}
		{if $section.articles}
			<div class="section mb-5">
				{if $section.title}
					<div class="border-bottom mb-3">
						<{$heading} class="h4 mb-0 text-primary py-2">
							{$section.title|escape}
						</{$heading}>
					</div>
				{/if}
				<div class="articles">
					{foreach from=$section.articles item=article}
						<div class="article-summary border-bottom py-3">
							{include file="frontend/objects/article_summary.tpl" heading=$articleHeading}
						</div>
					{/foreach}
				</div>
			</div>
		{/if}
	{/foreach}
	</div><!-- .sections -->
</div>
