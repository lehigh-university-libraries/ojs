<!-- Updated header.tpl (only navigation structure and dropdown adjusted) -->
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
{include file="frontend/components/headerHead.tpl"}
<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}" dir="{$currentLocaleLangDir|escape|default:"ltr"}">

<div class="pkp_structure_page">

  <header class="pkp_structure_head" role="banner">
    {include file="frontend/components/skipLinks.tpl"}

    <div class="header-inner">

      <!-- Branding row -->
      <div class="header-branding">
        <div class="header-logo">
          <a href="{$baseUrl}" class="is_img">
            <img src="{$baseUrl}/plugins/themes/lrsj/images/LRSJ_LU_logoC.png" alt="Lehigh University Logo" />
          </a>
        </div>
        <div class="header-text">
          <div class="journal-title">Lehigh Rising Scholars Journal</div>
          <div class="journal-tagline">Promoting academic excellence in engineering through peer review</div>
        </div>
      </div>

      <!-- Navigation row -->
      <nav class="header-nav" role="navigation">
        <ul class="nav-list">
		
		<li><a href="{url page='index'}" class="nav-link">Home</a></li>
		
          <li class="dropdown">
            <a href="#" class="nav-link">Browse Journal <span class="dropdown-icon">▾</span></a>
            <div class="dropdown-menu">
              <a href="{url page="issue" op="current"}">Current</a>
              <a href="{url page="issue" op="archive"}">Archives</a>
              <a href="{url page="search"}">Search</a>
            </div>
          </li>

			{* <li><a href="{url page='announcement'}" class="nav-link">Announcements</a></li> *}

          <li class="dropdown">
            <a href="#" class="nav-link">Guidelines <span class="dropdown-icon">▾</span></a>
            <div class="dropdown-menu">
              <a href="{url page="about" op="submissions"}">Author Guidelines</a>
              <a href="{url page="reviewer-guidelines"}">Reviewer Guidelines</a>
            </div>
          </li>

          <li class="dropdown">
            <a href="#" class="nav-link">About <span class="dropdown-icon">▾</span></a>
            <div class="dropdown-menu">
              <a href="{url page="about"}">About the Journal</a>
              <a href="{url page="about" op="editorialMasthead"}">Editorial Team</a>
              <a href="{url page="about" op="contact"}">Contact</a>
            </div>
          </li>

          {if $isUserLoggedIn}
            <li class="dropdown">
              <a href="#" class="nav-link">Profile <span class="dropdown-icon">▾</span></a>
              <div class="dropdown-menu">
                <a href="{url page="user"}">Dashboard</a>
                <a href="{url page="login" op="signOut"}">Logout</a>
              </div>
            </li>
          {else}
            <li><a href="{url page='login'}" class="nav-link">{translate key='user.login'}</a></li>
            <li><a href="{url page='user' op='register'}" class="nav-link">{translate key='user.register'}</a></li>
          {/if}
        </ul>
      </nav>

    </div>
  </header>


  {if $isFullWidth}{assign var=hasSidebar value=0}{/if}
  <div class="pkp_structure_content{if $hasSidebar} has_sidebar{/if}">
    <div class="pkp_structure_main" role="main">
      <a id="pkp_content_main"></a>
