{**
 * templates/frontend/pages/indexSite.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Site index - Bootstrap 5 styled for Lehigh theme
 *
 *}
{include file="frontend/components/header.tpl"}

<div class="page_index_site">
	<div class="container py-4">

		{if $highlights->count()}
			<div class="mb-4">
				{include file="frontend/components/highlights.tpl" highlights=$highlights}
			</div>
		{/if}

		{if $about}
			<div class="about_site mb-5">
				<div class="card shadow-sm">
					<div class="card-body p-4">
						{$about}
					</div>
				</div>
			</div>
		{/if}

		{include file="frontend/objects/announcements_list.tpl" numAnnouncements=$numAnnouncementsHomepage}

		<div class="journals">
			<h2 class="h3 mb-4">
				{translate key="context.contexts"}
			</h2>
			{if !$journals|@count}
				<div class="alert alert-info">
					{translate key="site.noJournals"}
				</div>
			{else}
				<div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
					{foreach from=$journals item=journal}
						{capture assign="url"}{url journal=$journal->getPath()}{/capture}
						{assign var="thumb" value=$journal->getLocalizedData('journalThumbnail')}
						{assign var="description" value=$journal->getLocalizedDescription()}
						<div class="col">
							<div class="card h-100 shadow-sm">
								{if $thumb}
									<a href="{$url}">
										<img
											src="{$journalFilesPath}{$journal->getId()}/{$thumb.uploadName|escape:"url"}"
											class="card-img-top"
											{if $thumb.altText}alt="{$thumb.altText|escape|default:''}"{/if}
											style="object-fit: cover; height: 200px;"
										>
									</a>
								{/if}

								<div class="card-body d-flex flex-column">
									<h3 class="card-title h5">
										<a href="{$url}" rel="bookmark" class="text-decoration-none">
											{$journal->getLocalizedName()|escape}
										</a>
									</h3>
									{if $description}
										<div class="card-text mb-3 flex-grow-1">
											{$description|truncate:150}
										</div>
									{/if}
									<div class="mt-auto">
										<div class="d-flex gap-2 flex-wrap">
											<a href="{$url}" class="btn btn-primary btn-sm">
												{translate key="site.journalView"}
											</a>
											<a href="{url journal=$journal->getPath() page="issue" op="current"}" class="btn btn-outline-primary btn-sm">
												{translate key="site.journalCurrent"}
											</a>
										</div>
									</div>
								</div>
							</div>
						</div>
					{/foreach}
				</div>
			{/if}
		</div>

	</div><!-- .container -->
</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
