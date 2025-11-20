{**
 * templates/frontend/objects/galley_link.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief View of a galley object as a link to view or download the galley, to be used
 *  in a list of galleys.
 *
 * @uses $galley Galley
 * @uses $parent Issue|Article Object which these galleys are attached to
 * @uses $publication Publication Optionally the publication (version) to which this galley is attached
 * @uses $isSupplementary bool Is this a supplementary file?
 * @uses $hasAccess bool Can this user access galleys for this context?
 * @uses $restrictOnlyPdf bool Is access only restricted to PDF galleys?
 * @uses $purchaseArticleEnabled bool Can this article be purchased?
 * @uses $currentJournal Journal The current journal context
 * @uses $journalOverride Journal An optional argument to override the current
 *       journal with a specific context
 *}

{* Override the $currentJournal context if desired *}
{if $journalOverride}
	{assign var="currentJournal" value=$journalOverride}
{/if}

{* Determine galley type and URL op *}
{if $galley->isPdfGalley()}
	{assign var="type" value="pdf"}
{else}
	{assign var="type" value="file"}
{/if}

{* Get path for URL *}
{if $parent instanceOf APP\issue\Issue}
	{assign var="page" value="issue"}
	{assign var="parentId" value=$parent->getBestIssueId()}
	{assign var="path" value=$parentId|to_array:$galley->getBestGalleyId()}
{else}{* APP\submission\Submission *}
	{assign var="page" value="article"}
	{if $publication}
		{if $publication->getId() !== $parent->getData('currentPublicationId')}
			{* Get a versioned link if we have an older publication *}
			{assign var="path" value=$parent->getBestId()|to_array:"version":$publication->getId():$galley->getBestGalleyId()}
		{else}
			{assign var="parentId" value=$publication->getData('urlPath')|default:$article->getId()}
			{assign var="path" value=$parentId|to_array:$galley->getBestGalleyId()}
		{/if}
	{else}
		{assign var="path" value=$parent->getBestId()|to_array:$galley->getBestGalleyId()}
	{/if}
{/if}

{* Get user access flag *}
{if !$hasAccess}
	{if $restrictOnlyPdf && $type=="pdf"}
		{assign var=restricted value="1"}
	{elseif !$restrictOnlyPdf}
		{assign var=restricted value="1"}
	{/if}
{/if}

{* Don't be frightened. This is just a link *}
<a class="btn {if $isSupplementary}btn-outline-secondary{else}btn-primary{/if} btn-sm {$type|escape}{if $restricted} restricted{/if}" href="{url page=$page op="view" path=$path}"{if $id} id="{$id}"{/if}{if $labelledBy} aria-labelledby="{$labelledBy}"{/if}>
	{* Add some screen reader text to indicate if a galley is restricted *}
	{if $restricted}
		<span class="visually-hidden">
			{if $purchaseArticleEnabled}
				{translate key="reader.subscriptionOrFeeAccess"}
			{else}
				{translate key="reader.subscriptionAccess"}
			{/if}
		</span>
		<i class="bi bi-lock-fill me-1"></i>
	{/if}

	{if $type == "pdf"}
		<i class="bi bi-file-pdf-fill me-1"></i>
	{else}
		<i class="bi bi-file-earmark-text-fill me-1"></i>
	{/if}
	{$galley->getGalleyLabel()|escape}

	{if $restricted && $purchaseFee && $purchaseCurrency}
		<span class="badge bg-warning text-dark ms-2">
			{translate key="reader.purchasePrice" price=$purchaseFee currency=$purchaseCurrency}
		</span>
	{/if}
</a>
