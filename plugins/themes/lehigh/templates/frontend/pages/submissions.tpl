{**
 * templates/frontend/pages/submissions.tpl
 *
 * Copyright (c) 2014-2023 Simon Fraser University
 * Copyright (c) 2003-2023 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display the page to view information about submissions.
 *}
{capture assign="submissionChecklistAfterContent"}
    <div class="container-fluid my-4">
        <div class="row g-4">
            {foreach from=$sections item="section"}
                {if $section->getLocalizedPolicy()}
                    <div class="col-12">
                        <div class="card shadow-sm h-100">
                            <div class="card-header bg-primary text-white">
                                <h2 class="h4 mb-0">{$section->getLocalizedTitle()|escape}</h2>
                            </div>
                            <div class="card-body">
                                <div class="section-policy-content mb-3">
                                    {$section->getLocalizedPolicy()}
                                </div>
                                {if $isUserLoggedIn}
                                    {capture assign="sectionSubmissionUrl"}{url page="submission" sectionId=$section->getId()}{/capture}
                                    <div class="alert alert-info d-flex align-items-center" role="alert">
                                        <i class="bi bi-info-circle-fill me-2"></i>
                                        <div>
                                            {translate key="about.onlineSubmissions.submitToSection" name=$section->getLocalizedTitle()|escape url=$sectionSubmissionUrl}
                                        </div>
                                    </div>
                                {/if}
                            </div>
                        </div>
                    </div>
                {/if}
            {/foreach}
        </div>
    </div>
{/capture}

{include file="core:frontend/pages/submissions.tpl"}
