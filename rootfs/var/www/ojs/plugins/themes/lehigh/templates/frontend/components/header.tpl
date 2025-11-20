<!-- Updated header.tpl (only navigation structure and dropdown adjusted) -->
<!DOCTYPE html>
<html lang="{$currentLocale|replace:" _":"-"}" xml:lang="{$currentLocale|replace:" _":"-"}">
    {if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
    {include file="frontend/components/headerHead.tpl"}

    <body class="pkp_page_{$requestedPage|escape|default:" index"} pkp_op_{$requestedOp|escape|default:"index"}"
        dir="{$currentLocaleLangDir|escape|default:" ltr"}">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
            integrity="sha256-2FMn2Zx6PuH5tdBQDRNwrOo60ts5wWPC9R8jK67b3t4=" crossorigin="anonymous">
        <link rel="stylesheet" href="https://www.lehigh.edu/~inltswms/include/ltstemplate/css/lehigh-reset.min.css">
        <link rel="stylesheet" href="https://www.lehigh.edu/~inltswms/include/ltstemplate/css/styles.min.css">
        <div class="pkp_structure_page">
            <header class="lehigh-header border-bottom">
                <nav class="lehigh-nav lehigh-header-nav lehigh-navbar">
                    <div class="lehigh-branding">
                        <div class="lehigh-container-fluid">

                            <div class="lehigh-row lehigh-align-items-center">
                                <div class="utility-nav--start lehigh-navbar-brand leh-col-md-4">
                                    {if $currentJournal}
                                        {assign var="journalLogo" value=$currentJournal->getLocalizedData('pageHeaderLogoImage')}
                                        {if $journalLogo}
                                            <img src="{$publicFilesDir}/{$journalLogo.uploadName|escape:"url"}" {if $journalLogo.altText}alt="{$journalLogo.altText|escape}"{else}alt="{$currentJournal->getLocalizedName()|escape}"{/if}
                                                width="300px" />
                                        {else}
                                            <img src="https://lehigh.edu/~inltswms/images/logos/lehighuniversity-lts-wordmark.svg"
                                                width="300px" height="43" alt="Lehigh University" />
                                        {/if}
                                    {else}
                                        <img src="https://lehigh.edu/~inltswms/images/logos/lehighuniversity-lts-wordmark.svg"
                                            width="300px" height="43" alt="Lehigh University" />
                                    {/if}
                                </div>
                                <!-- utility-nav--start -->
                                <div class="utility-nav--mid leh-col-md-8">
                                    <div class="lehigh-navbarSupportedContent">
                                        <ul class="lehigh-d-flex lehigh-justify-content-between">
                                            <li><a href="{url page='index'}">Home</a></li>

                                            {* Primary navigation from OJS navigation system *}
                                            {if $enableAnnouncements}
                                            <li>
                                                <a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="announcement"}">
                                                    {translate key="announcement.announcements"}
                                                </a>
                                            </li>
                                            {/if}

                                            {if $currentJournal}
                                            {if $currentJournal->getData('publishingMode') != $PUBLISHING_MODE_NONE}
                                            <li>
                                                <a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="current" }">
                                                    {translate key="navigation.current"}
                                                </a>
                                            </li>
                                            <li>
                                                <a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive" }">
                                                    {translate key="navigation.archives"}
                                                </a>
                                            </li>
                                            {/if}

                                            <li>
                                                <a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about"}">
                                                    {translate key="navigation.about"}
                                                </a>
                                            </li>
                                            {/if}

                                            {* User navigation *}
                                            {if $isUserLoggedIn}
                                            <li><a href="{url page="user"}">Dashboard</a></li>
                                            <li><a href="{url page="login" op="signOut" }">Logout</a></li>
                                            {else}
                                            <li>
                                                <a href="{url page='login'}" class="nav-link">
                                                    {translate key='user.login'}
                                                </a>
                                            </li>
                                            {/if}
                                        </ul>
                                    </div>
                                </div><!-- end utility-nav--mid -->
                            </div>
                        </div>
                    </div><!-- end container-fluid -->
                    <div class="lehigh-main-nav">
                        <div class="lehigh-container-fluid">
                            <button id="lehigh-navbar-toggler" type="button"
                                aria-controls="lehigh-navbarSupportedContent" aria-expanded="false"
                                aria-label="Toggle navigation">
                                <span class="navbar-toggler-icon">
                                    <img class="icon icon-close open"
                                        src="https://www.lehigh.edu/~inltswms/images/icons/menu.svg" alt="">
                                    <img class="icon close"
                                        src="https://www.lehigh.edu/~inltswms/images/icons/close.svg" alt="">
                                </span>
                            </button>
                            <div class="nav-wrapper lehigh-max-width lehigh-mx-auto">
                                <div class="primary-nav--sub-links">
                                    <a href="{url page='index'}">Home</a>

                                    {* Primary navigation from OJS navigation system *}
                                    {if $enableAnnouncements}
                                    <a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="announcement"}">
                                        {translate key="announcement.announcements"}
                                    </a>
                                    {/if}

                                    {if $currentJournal}
                                    {if $currentJournal->getData('publishingMode') != $PUBLISHING_MODE_NONE}
                                    <a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="current" }">
                                        {translate key="navigation.current"}
                                    </a>
                                    <a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive" }">
                                        {translate key="navigation.archives"}
                                    </a>

                                    {/if}


                                    <a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" }">
                                        {translate key="navigation.about"}
                                    </a>

                                    {/if}

                                    {* User navigation *}
                                    {if $isUserLoggedIn}
                                    <a href="{url page="user" }">Dashboard</a>
                                    <a href="{url page="login" op="signOut" }">Logout</a>
                                    {else}
                                    <a href="{url page='login'}" class="nav-link">
                                        {translate key='user.login'}
                                    </a>
                                    {/if}
                                </div>
                            </div>

                        </div>

                    </div>
                </nav>
            </header>
            <div class="container">