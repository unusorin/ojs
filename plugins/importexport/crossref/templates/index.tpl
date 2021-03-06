{**
 * plugins/importexport/crossref/templates/index.tpl
 *
 * Copyright (c) 2014-2016 Simon Fraser University Library
 * Copyright (c) 2003-2016 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * List of operations this plugin can perform
 *}
{strip}
{include file="common/header.tpl" pageTitle="plugins.importexport.crossref.displayName"}
{/strip}

{if !empty($configurationErrors) || !$currentContext->getSetting('publisherInstitution')|escape || (!$exportArticles && !$exportIssues)}
	{assign var="allowExport" value=false}
{else}
	{assign var="allowExport" value=true}
{/if}

<script type="text/javascript">
	// Attach the JS file tab handler.
	$(function() {ldelim}
		$('#importExportTabs').pkpHandler('$.pkp.controllers.TabHandler');
	{rdelim});
</script>
<div id="importExportTabs">
	<ul>
		<li><a href="#settings-tab">{translate key="plugins.importexport.common.settings"}</a></li>
		{if $allowExport}
			{if $exportArticles}
				<li><a href="#exportSubmissions-tab">{translate key="plugins.importexport.common.export.articles"}</a></li>
			{/if}
			{if $exportIssues}
				<li><a href="#exportIssues-tab">{translate key="plugins.importexport.common.export.issues"}</a></li>
			{/if}
		{/if}
	</ul>
	<div id="settings-tab">
		{if !$allowExport}
			<div class="pkp_notification" id="crossrefConfigurationErrors">
				{foreach from=$configurationErrors item=configurationError}
					{if $configurationError == $smarty.const.DOI_EXPORT_CONFIG_ERROR_DOIPREFIX}
						{include file="controllers/notification/inPlaceNotificationContent.tpl" notificationId=crossrefConfigurationErrors notificationStyleClass=notifyWarning notificationTitle="plugins.importexport.common.missingRequirements"|translate notificationContents="plugins.importexport.common.error.DOIsNotAvailable"|translate}
					{elseif $configurationError == $smarty.const.DOI_EXPORT_CONFIG_ERROR_SETTINGS}
						{include file="controllers/notification/inPlaceNotificationContent.tpl" notificationId=crossrefConfigurationErrors notificationStyleClass=notifyWarning notificationTitle="plugins.importexport.common.missingRequirements"|translate notificationContents="plugins.importexport.common.error.pluginNotConfigured"|translate}
					{/if}
				{/foreach}
				{if !$currentContext->getSetting('publisherInstitution')|escape}
					{include file="controllers/notification/inPlaceNotificationContent.tpl" notificationId=crossrefConfigurationErrors notificationStyleClass=notifyWarning notificationTitle="plugins.importexport.common.missingRequirements"|translate notificationContents="plugins.importexport.crossref.error.publisherNotConfigured"|translate}
				{/if}
				{if !$exportArticles && !$exportIssues}
					{include file="controllers/notification/inPlaceNotificationContent.tpl" notificationId=crossrefConfigurationErrors notificationStyleClass=notifyWarning notificationTitle="plugins.importexport.common.missingRequirements"|translate notificationContents="plugins.importexport.crossref.error.noDOIContentObjects"|translate}
				{/if}
			</div>
		{/if}

		{url|assign:crossrefSettingsGridUrl router=$smarty.const.ROUTE_COMPONENT component="grid.settings.plugins.settingsPluginGridHandler" op="manage" plugin="CrossRefExportPlugin" category="importexport" verb="index" escape=false}
		{load_url_in_div id="crossrefSettingsGridContainer" url=$crossrefSettingsGridUrl}
	</div>

	{if $allowExport}
		{if $exportArticles}
			<div id="exportSubmissions-tab">
				<script type="text/javascript">
					$(function() {ldelim}
						// Attach the form handler.
						$('#exportSubmissionXmlForm').pkpHandler('$.pkp.controllers.form.DOIPubIdExportFormHandler');
					{rdelim});
				</script>
				<form id="exportSubmissionXmlForm" class="pkp_form" action="{plugin_url path="exportSubmissions"}" method="post">
					{fbvFormArea id="submissionsXmlForm"}
						{url|assign:submissionsListGridUrl router=$smarty.const.ROUTE_COMPONENT component="grid.pubIds.PubIdExportSubmissionsListGridHandler" op="fetchGrid" plugin="crossref" category="importexport" escape=false}
						{load_url_in_div id="submissionsListGridContainer" url=$submissionsListGridUrl}
						{if !empty($linkActions)}
							<ul class="pubids_export_actions">
								{foreach from=$linkActions item=linkAction}
									<li class="pkp_button_link">
										{include file="linkAction/linkAction.tpl" action=$linkAction}
									</li>
								{/foreach}
							</ul>
						{/if}
					{/fbvFormArea}
				</form>
				<p>{translate key="plugins.importexport.crossref.statusLegend"}</p>
			</div>
		{/if}
		{if $exportIssues}
			<div id="exportIssues-tab">
				<script type="text/javascript">
					$(function() {ldelim}
						// Attach the form handler.
						$('#exportIssueXmlForm').pkpHandler('$.pkp.controllers.form.DOIPubIdExportFormHandler');
					{rdelim});
				</script>
				<p>{translate key="plugins.importexport.crossref.issues.description"}</p>
				<form id="exportIssueXmlForm" class="pkp_form" action="{plugin_url path="exportIssues"}" method="post">
					{fbvFormArea id="issuesXmlForm"}
						{url|assign:issuesListGridUrl router=$smarty.const.ROUTE_COMPONENT component="grid.pubIds.PubIdExportIssuesListGridHandler" op="fetchGrid" plugin="crossref" category="importexport" escape=false}
						{load_url_in_div id="issuesListGridContainer" url=$issuesListGridUrl}
						{if !empty($linkActions)}
							<ul class="pubids_export_actions">
								{foreach from=$linkActions item=linkAction}
									<li class="pkp_button_link">
										{include file="linkAction/linkAction.tpl" action=$linkAction}
									</li>
								{/foreach}
							</ul>
						{/if}
					{/fbvFormArea}
				</form>
				<p>{translate key="plugins.importexport.crossref.statusLegend"}</p>
			</div>
		{/if}
	{/if}
</div>

{include file="common/footer.tpl"}

