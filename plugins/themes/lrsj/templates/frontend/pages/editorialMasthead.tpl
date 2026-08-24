{**
 * Custom masthead: 3 sections
 *   1. Editor-in-Chief(s)
 *   2. Editorial Board (all other masthead roles)
 *   3. Peer Reviewers
 *}

{include file="frontend/components/header.tpl" pageTitle="common.editorialMasthead"}

<div class="page page_masthead">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="common.editorialMasthead"}

	<h1>{translate key="common.editorialMasthead"}</h1>


	{assign var=lastRole value=""}

	{foreach from=$customMasthead item=entry}
		{if $entry.role != $lastRole}
			{if $lastRole != ""}</ul>{/if}
			<h2>{$entry.role}</h2>
			<ul class="user_listing" role="list">
			{assign var=lastRole value=$entry.role}
		{/if}
        <li class="masthead-person">
          <img 
            src="{$baseUrl}/plugins/themes/lrsj/images/eboard/{$entry.ID}.png" 
            class="masthead-photo"
          >
          <div class="masthead-details">
            <div class="user_name">{$entry.name}</div>
            {if $entry.affiliation}
              <div class="user_affiliation">{$entry.affiliation}</div>
            {/if}
            {if $entry.email}
              <div class="user_email">{$entry.email}</div>
            {/if}
          </div>
        </li>
	{/foreach}
	</ul>

</div>

{include file="frontend/components/footer.tpl"}
