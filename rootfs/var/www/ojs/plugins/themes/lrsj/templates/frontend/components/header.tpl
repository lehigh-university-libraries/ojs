<!-- Updated header.tpl (only navigation structure and dropdown adjusted) -->
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
{include file="frontend/components/headerHead.tpl"}
<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}" dir="{$currentLocaleLangDir|escape|default:"ltr"}">
    <link rel="stylesheet" href="https://www.lehigh.edu/~inltswms/include/ltstemplate/css/lehigh-reset.min.css">
    <link rel="stylesheet" href="https://www.lehigh.edu/~inltswms/include/ltstemplate/css/styles.min.css">
<style>
  .lehigh-header .lehigh-nav.lehigh-header-nav .lehigh-main-nav .nav-wrapper .lehigh-navlist li a {
    font-size: 1.25rem !important;
  }
  #lehigh-navbar-toggler,
  .lehigh-main-nav,
  .lehigh-nav.lehigh-header-nav .lehigh-branding {
    background-color: #5b3924 !important;
  }
  .lehigh-main-nav .lehigh-container-fluid {
    width: 75%;
  }
</style>
    <div class="pkp_structure_page">
      <header class="lehigh-header pkp_structure_head">
        {include file="frontend/components/skipLinks.tpl"}
        <nav class="lehigh-nav lehigh-header-nav lehigh-navbar">
          <div class="lehigh-branding">
            <div class="lehigh-container-fluid">
              <div class="lehigh-row lehigh-align-items-center">
                <div class="utility-nav--start lehigh-navbar-brand leh-col-md-4">
                  <img src="{$baseUrl}/plugins/themes/lrsj/images/LRSJ_LU_logoC.png"
                    alt="Lehigh Rising Scholar Journal Logo" width="300px" />
                </div>
                <div class="leh-col-md-8 header-text">
                  <h2 class="journal-title">Lehigh Rising Scholars Journal</h2>
                  <p class="journal-tagline">Promoting academic excellence in engineering through peer review</p>
                </div>
              </div>
            </div>
          </div><!-- end container-fluid -->
          <div class="lehigh-main-nav">
            <div class="lehigh-container-fluid">
              <button id="lehigh-navbar-toggler" type="button" aria-controls="lehigh-navbarSupportedContent"
                aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon">
                  <img class="icon icon-close open" src="https://www.lehigh.edu/~inltswms/images/icons/menu.svg" alt="">
                  <img class="icon close" src="https://www.lehigh.edu/~inltswms/images/icons/close.svg" alt="">
                </span>
              </button>
              <div class="nav-wrapper lehigh-max-width lehigh-mx-auto">
                <div class="lehigh-row">
                  <ul class="lehigh-navlist lehigh-justify-content-between lehigh-align-items-center">
                    <li><a href="{url page='index'}">Home</a></li>
                    <li class="lehigh-dropdown">
                      <a class="lehigh-dropdown-toggle" href="#" id="browseDropdown" role="button"
                        aria-expanded="false">
                        <span>Browse Journal</span>
                        <img class="icon" src="https://www.lehigh.edu/~inltswms/images/icons/expand_more.svg"
                          alt="Location" width="24" height="24" />
                      </a>
                      <div class="lehigh-dropdown-menu" aria-labelledby="browseDropdown">
                        <div class="nav-section">
                          <ul>
                            <li><a href="{url page="issue" op="current"}">Current</a></li>
                            <li><a href="{url page="issue" op="archive"}">Archives</a></li>
                            <li><a href="{url page="search"}">Search</a></li>
                          </ul>
                        </div>
                      </div>
                    </li>
                    <li class="lehigh-dropdown">
                      <a class="lehigh-dropdown-toggle" href="#" id="guidelinesDropdown" role="button"
                        aria-expanded="false">Guidelines
                        <img class="icon" src="https://www.lehigh.edu/~inltswms/images/icons/expand_more.svg"
                          alt="Location" width="24" height="24" />
                      </a>
                      <div class="lehigh-dropdown-menu" aria-labelledby="guidelinesDropdown">
                        <div class="nav-section">
                          <ul>
                            <li><a href="{url page="about" op="submissions"}">Author Guidelines</a></li>
                            <li><a href="{url page="reviewer-guidelines"}">Reviewer Guidelines</a></li>
                          </ul>
                        </div>
                      </div>
                    </li>
                    <li class="lehigh-dropdown">
                      <a class="lehigh-dropdown-toggle" href="#" id="aboutDropDown" role="button"
                        aria-expanded="false">About
                        <img class="icon" src="https://www.lehigh.edu/~inltswms/images/icons/expand_more.svg"
                          alt="Location" width="24" height="24" />
                      </a>
                      <div class="lehigh-dropdown-menu" aria-labelledby="aboutDropDown">
                        <div class="nav-section">
                          <ul>
                            <li><a href="{url page="about"}">About the Journal</a></li>
                            <li><a href="{url page="about" op="editorialMasthead"}">Editorial Team</a></li>
                            <li><a href="{url page="about" op="contact"}">Contact</a></li>
                          </ul>
                        </div>
                      </div>
                    </li>
                    {if $isUserLoggedIn}
                      <li class="lehigh-dropdown">
                        <a class="lehigh-dropdown-toggle" href="#" id="profileDropDown" role="button"
                          aria-expanded="false">Profile
                          <img class="icon" src="https://www.lehigh.edu/~inltswms/images/icons/expand_more.svg"
                            alt="Location" width="24" height="24" />
                        </a>
                        <div class="lehigh-dropdown-menu" aria-labelledby="profileDropDown">
                          <div class="nav-section">
                            <ul>
                              <li><a href="{url page="user"}">Dashboard</a></li>
                              <li><a href="{url page="login" op="signOut"}">Logout</a></li>
                            </ul>
                          </div>
                        </div>
                      </li>
                    {else}
                      <li>
                        <a href="{url page='login'}" class="nav-link">
                          {translate key='user.login'}
                        </a>
                      </li>
                      <li>
                        <a href="{url page='user' op='register'}" class="nav-link">
                          {translate key='user.register'}
                        </a>
                      </li>
                    {/if}
                  </ul>
                </div>
              </div><!-- end nav-wrapper -->
            </div><!-- end container fluid -->
          </div><!-- end main-nav -->
        </nav>
      </header>

      {if $isFullWidth}{assign var=hasSidebar value=0}{/if}
      <div class="pkp_structure_content{if $hasSidebar} has_sidebar{/if}">
        <div class="pkp_structure_main" role="main">
          <a id="pkp_content_main"></a>
