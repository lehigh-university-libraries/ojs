{**
 * templates/frontend/components/pagination.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Common template for displaying pagination - Bootstrap 5 styled
 *
 * @uses $prevUrl string URL to the previous page
 * @uses $nextUrl string URL to the next page
 * @uses $showingStart int The number of the first item shown on this page
 * @uses $showingEnd int The number of the last item shown on this page
 * @uses $total int The total number of items available
 *}

{if $prevUrl || $nextUrl}
	<nav aria-label="{translate|escape key="common.pagination.label"}">
		<ul class="pagination justify-content-center">
			{if $prevUrl}
				<li class="page-item">
					<a class="page-link" href="{$prevUrl}">
						{translate key="help.previous"}
					</a>
				</li>
			{else}
				<li class="page-item disabled">
					<span class="page-link">{translate key="help.previous"}</span>
				</li>
			{/if}

			<li class="page-item disabled">
				<span class="page-link">
					{translate key="common.pagination" start=$showingStart end=$showingEnd total=$total}
				</span>
			</li>

			{if $nextUrl}
				<li class="page-item">
					<a class="page-link" href="{$nextUrl}">
						{translate key="help.next"}
					</a>
				</li>
			{else}
				<li class="page-item disabled">
					<span class="page-link">{translate key="help.next"}</span>
				</li>
			{/if}
		</ul>
	</nav>
{/if}
