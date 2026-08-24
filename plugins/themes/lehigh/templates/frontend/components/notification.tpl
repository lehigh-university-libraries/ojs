{**
 * templates/frontend/components/notification.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief View of an embedded notification element - Bootstrap 5 styled
 *
 * @uses $type string A class which will be added to the notification element
 * @uses $message string The notification message
 * @uses $messageKey string Optional translation key to generate the message
 *}
{assign var="alertClass" value="alert-info"}
{if $type == "success"}
	{assign var="alertClass" value="alert-success"}
{elseif $type == "warning"}
	{assign var="alertClass" value="alert-warning"}
{elseif $type == "error" || $type == "danger"}
	{assign var="alertClass" value="alert-danger"}
{/if}

<div class="alert {$alertClass} cmp_notification {$type|escape|replace:' ':'_'}" role="alert">
	{if $messageKey}
		{translate key=$messageKey}
	{else}
		{$message}
	{/if}
</div>
