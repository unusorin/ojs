{**
 * submissionReview.tpl
 *
 * Copyright (c) 2003-2004 The Public Knowledge Project
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Show the details of a submission.
 *
 * FIXME: Editor decision values need to be localized.
 * DO: Reviewer comments need to be implemented.
 *
 * $Id$
 *}

{assign var="pageTitle" value="submission.submission"}
{include file="common/header.tpl"}

<ul id="tabnav">
	<li><a href="{$pageUrl}/sectionEditor/summary/{$submission->getArticleId()}">{translate key="submission.summary"}</a></li>
	<li><a href="{$pageUrl}/sectionEditor/submission/{$submission->getArticleId()}">{translate key="submission.submission"}</a></li>
	<li><a href="{$pageUrl}/sectionEditor/submissionReview/{$submission->getArticleId()}" class="active">{translate key="submission.submissionReview"}</a></li>
	<li><a href="{$pageUrl}/sectionEditor/submissionEditing/{$submission->getArticleId()}">{translate key="submission.submissionEditing"}</a></li>
	<li><a href="{$pageUrl}/sectionEditor/submissionHistory/{$submission->getArticleId()}">{translate key="submission.submissionHistory"}</a></li>
</ul>
<ul id="subnav">
{section name="tabRounds" start=0 loop=$submission->getCurrentRound()}
	{assign var="tabRound" value=$smarty.section.tabRounds.index+1}
	<li><a href="{$pageUrl}/sectionEditor/submissionReview/{$submission->getArticleId()}/{$tabRound}" {if $round eq $tabRound}class="active"{/if}>{translate key="submission.round" round=$tabRound}</a></li>
{/section}
</ul>

<div class="tableContainer">
<table width="100%">
<tr class="submissionRow">
	<td class="submissionBox">
		<div class="leftAligned">
			<div>{foreach from=$submission->getAuthors() item=author key=authorKey}{if $authorKey neq 0},{/if} {$author->getFullName()}{/foreach}</div>
			<div class="submissionTitle">{$submission->getArticleTitle()}</div>
		</div>
		<div class="submissionId">{$submission->getArticleId()}</div>
	</td>
</tr>
</table>
</div>

<br />

<div class="tableContainer">
<table width="100%">
<tr class="heading">
	<td colspan="2">{translate key="submission.reviewVersion"}</td>
</tr>
<tr class="submissionRow">
	<td class="submissionBox" width="50%" valign="top">
		<span class="boldText">{translate key="editor.article.originalFile"}:</span>
		{if $submissionFile}
			<a href="{$pageUrl}/sectionEditor/downloadFile/{$submissionFile->getFileId()}" class="file">{$submissionFile->getFileName()}</a> {$submissionFile->getDateModified()|date_format:$dateFormatShort}
		{else}
			{translate key="common.none"}
		{/if}
		{if $reviewFile}
			<div class="indented">
				<form method="post" action="{$pageUrl}/sectionEditor/designateReviewVersion">
					<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
					<input type="checkbox" name="designate" value="1" disabled="disabled"> <span class="disabledText">{translate key="editor.article.designateReviewVersion"}</span>
					<input type="submit" value="{translate key="common.record"}" disabled="disabled">
				</form>
			</div>
		{else}
			<div class="indented">
				<form method="post" action="{$pageUrl}/sectionEditor/designateReviewVersion">
					<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
					<input type="checkbox" name="designate" value="1"> {translate key="editor.article.designateReviewVersion"}
					<input type="submit" value="{translate key="common.record"}">
				</form>
			</div>	
		{/if}
	</td>
	<td class="submissionBox" width="50%" valign="top">
		<span class="boldText">{translate key="editor.article.reviewVersion"}:</span>
		{if $reviewFile}
			<a href="{$pageUrl}/sectionEditor/downloadFile/{$reviewFile->getFileId()}" class="file">{$reviewFile->getFileName()}</a> {$reviewFile->getDateModified()|date_format:$dateFormatShort}
		{else}
			{translate key="common.none"}
		{/if}
		<div class="indented">
			<form method="post" action="{$pageUrl}/sectionEditor/uploadReviewVersion" enctype="multipart/form-data">
				<input type="hidden" name="articleId" value="{$submission->getArticleId()}" />
				<input type="file" name="upload">
				<input type="submit" name="submit" value="{translate key="common.upload"}">
			</form>
		</div>
	</td>
</tr>
</table>
</div>

<br />

<a name="peerReview"></a>
<div class="tableContainer">
<table width="100%">
<tr class="heading">
	<td>{translate key="submission.peerReview"}</td>
</tr>
{assign var="start" value="A"|ord} 
{assign var="numReviewAssignments" value=$reviewAssignments|@count} 
{foreach from=$reviewAssignments item=reviewAssignment key=reviewKey}
{assign var="reviewId" value=$reviewAssignment->getReviewId()}
<tr class="submissionRowAlt">
	<td class="submissionBox">
		<table class="plainFormat" width="100%">
			<tr>
				<td width="40%">
					<span class="boldText">{$reviewKey+$start|chr}.</span>
					{$reviewAssignment->getReviewerFullName()}
				</td>
				<td width="60%">
					<table class="plainFormat" width="100%">
						<tr>
							<td align="center"><strong>{translate key="submission.request"}</strong></td>
							<td align="center"><strong>{translate key="submission.acceptance"}</strong></td>
							<td align="center">
								<form method="post" action="{$pageUrl}/editor/setDueDate/{$reviewAssignment->getArticleId()}/{$reviewAssignment->getReviewId()}">
									<input type="hidden" name="reviewId" value="{$reviewAssignment->getReviewId()}">
									<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
									<input type="submit" value=" {translate key="submission.due"}">
								</form>
							</td>
							<td align="center">
								<form method="post" action="{$pageUrl}/sectionEditor/thankReviewer">
									<input type="hidden" name="reviewId" value="{$reviewAssignment->getReviewId()}">
									<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
									<input type="submit" value="{translate key="submission.thank"}">
								</form>
							</td>
						</tr>
						<tr>
							<td align="center">{if $reviewAssignment->getDateNotified()}{$reviewAssignment->getDateNotified()|date_format:$dateFormatShort}{else}-{/if}</td>
							<td align="center">{if $reviewAssignment->getDateConfirmed()}{$reviewAssignment->getDateConfirmed()|date_format:$dateFormatShort}{else}-{/if}</td>
							<td align="center">{if $reviewAssignment->getDateDue()}{$reviewAssignment->getDateDue()|date_format:$dateFormatShort}{else}<a href="{$pageUrl}/editor/setDueDate/{$reviewAssignment->getArticleId()}/{$reviewAssignment->getReviewId()}">{translate key="editor.article.setDueDate"}</a>{/if}</td>
							<td align="center">{if $reviewAssignment->getDateAcknowledged()}{$reviewAssignment->getDateAcknowledged()|date_format:$dateFormatShort}{else}-{/if}</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</td>
</tr>
<tr class="submissionRow">
	<td class="submissionBox">
		<table class="plainFormat" width="100%">
			<tr>
				<td class="reviewLabel">
					<span class="boldText">{translate key="reviewer.article.recommendation"}</span>
				</td>
				<td>
					{if $reviewAssignment->getRecommendation()}
						{assign var="recommendation" value=$reviewAssignment->getRecommendation()}
						<span class="boldTextAlt">{translate key=$reviewerRecommendationOptions.$recommendation}</span>
					{else}
						{translate key="common.none"}
					{/if}
				</td>
			</tr>
			<tr>
				<td class="reviewLabel">
					<span class="boldText">{translate key="reviewer.article.reviewerComments"}</span>
				</td>
				<td>
					<a href="#">...</a>
				</td>
			</tr>
			<tr>
				<td class="reviewLabel">
					<span class="boldText">{translate key="reviewer.article.uploadedFile"}</span>
				</td>
				<td>
					<form name="authorView{$reviewAssignment->getReviewId()}" method="post" action="{$pageUrl}/sectionEditor/makeReviewerFileViewable">
						<input type="hidden" name="reviewId" value="{$reviewAssignment->getReviewId()}">
						<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
						{if $reviewAssignment->getReviewerFileId()}
							{assign var="reviewerFile" value=$reviewAssignment->getReviewerFile()}
							<a href="{$pageUrl}/sectionEditor/downloadFile/{$reviewerFile->getFileId()}">{$reviewerFile->getFileName()}</a>
							<input type="checkbox" name="viewable" value="1" {if $reviewAssignment->getReviewerFileViewable()}checked="checked"{/if}> {translate key="editor.article.showAuthor"}
							<input type="submit" value="{translate key="common.record"}">
						{else}
							{translate key="common.none"}
						{/if}
					</form>
				</td>
			</tr>
			<tr>
				<td class="reviewLabel">
					<form method="post" action="{$pageUrl}/sectionEditor/notifyReviewer">
						<input type="hidden" name="reviewId" value="{$reviewAssignment->getReviewId()}">
						<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
						<span class="boldText">{translate key="editor.article.toReviewer"}</span><input type="image" src="{$baseUrl}/templates/images/mail.gif">
					</form>
				</td>
				<td>
					{foreach from=$notifyReviewerLogs[$reviewId] item=emailLog}
						<img src="{$baseUrl}/templates/images/letter.gif" />{$emailLog->getDateSent()|date_format:$dateFormatShort}
					{/foreach}
				</td>
			</tr>
			<tr>
				<td class="reviewLabel">
					<span class="boldText">{translate key="editor.article.rateReviewer"}</span>
				</td>
				<td>
					<form method="post" action="{$pageUrl}/sectionEditor/rateReviewer">
						<input type="hidden" name="reviewId" value="{$reviewAssignment->getReviewId()}">
						<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
						<table class="plainFormat">
							<tr>
								<td align="right">
									<span class="boldText">{translate key="editor.article.timeliness"}</span>
								</td>
								<td>
									<select name="timeliness">
										<option value="5" {if $reviewAssignment->getTimeliness() eq 5}selected="selected"{/if}>5 High</option>
										<option value="4" {if $reviewAssignment->getTimeliness() eq 4}selected="selected"{/if}>4</option>
										<option value="3" {if $reviewAssignment->getTimeliness() eq 3}selected="selected"{/if}>3</option>
										<option value="2" {if $reviewAssignment->getTimeliness() eq 2}selected="selected"{/if}>2</option>
										<option value="1" {if $reviewAssignment->getTimeliness() eq 1}selected="selected"{/if}>1 Low</option>
									</select>
								</td>
								<td align="right">
									<span class="boldText">{translate key="editor.article.quality"}</span>
								</td>
								<td>
									<select name="quality">
										<option value="5" {if $reviewAssignment->getQuality() eq 5}selected="selected"{/if}>5 High</option>
										<option value="4" {if $reviewAssignment->getQuality() eq 4}selected="selected"{/if}>4</option>
										<option value="3" {if $reviewAssignment->getQuality() eq 3}selected="selected"{/if}>3</option>
										<option value="2" {if $reviewAssignment->getQuality() eq 2}selected="selected"{/if}>2</option>
										<option value="1" {if $reviewAssignment->getQuality() eq 1}selected="selected"{/if}>1 Low</option>

									</select>
								</td>
								<td>
									<input type="submit" value="{translate key="common.record"}">
								</td>
							</tr>
						</table>
					</form>
				</td>
			</tr>
			<tr>
				<td></td>
				<td>
					{if $reviewAssignment->getRecommendation()}
						<div class="leftAligned">
							<form method="post" action="{$pageUrl}/sectionEditor/reinitiateReview">
								<input type="hidden" name="reviewId" value="{$reviewAssignment->getReviewId()}">
								<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
								<input type="submit" value="{translate key="editor.article.initiateReview"}" disabled="disabled">
							</form>
						</div>
						<div class="rightAligned">
							<form method="post" action="{$pageUrl}/sectionEditor/cancelReview">
								<input type="hidden" name="reviewId" value="{$reviewAssignment->getReviewId()}">
								<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
								<input type="submit" value="{translate key="editor.article.cancelReview"}" disabled="disabled">
							</form>
						</div>
						<div class="rightAligned">
							<form method="post" action="{$pageUrl}/sectionEditor/enterReviewerRecommendation">
								<input type="hidden" name="reviewId" value="{$reviewAssignment->getReviewId()}">
								<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
								<input type="submit" value="{translate key="editor.article.enterRecommendation"}" disabled="disabled">
							</form>
						</div>
					{elseif not $reviewAssignment->getDateInitiated() and not $reviewAssignment->getCancelled()}
						<div class="leftAligned">
							<form method="post" action="{$pageUrl}/sectionEditor/initiateReview">
								<input type="hidden" name="reviewId" value="{$reviewAssignment->getReviewId()}">
								<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
								<input type="submit" value="{translate key="editor.article.initiateReview"}">
							</form>
						</div>
						<div class="rightAligned">
							<form method="post" action="{$pageUrl}/sectionEditor/removeReview">
								<input type="hidden" name="reviewId" value="{$reviewAssignment->getReviewId()}">
								<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
								<input type="submit" value="{translate key="editor.article.removeReview"}">
							</form>
						</div>
						<div class="rightAligned">
							<form method="post" action="{$pageUrl}/sectionEditor/enterReviewerRecommendation">
								<input type="hidden" name="reviewId" value="{$reviewAssignment->getReviewId()}">
								<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
								<input type="submit" value="{translate key="editor.article.enterRecommendation"}" disabled="disabled">
							</form>
						</div>
					{elseif $reviewAssignment->getDateInitiated() and not $reviewAssignment->getCancelled()}
						<div class="leftAligned">
							<form method="post" action="{$pageUrl}/sectionEditor/initiateReview">
								<input type="hidden" name="reviewId" value="{$reviewAssignment->getReviewId()}">
								<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
								<input type="submit" value="{translate key="editor.article.initiateReview"}" disabled="disabled">
							</form>
						</div>
						<div class="rightAligned">
							<form method="post" action="{$pageUrl}/sectionEditor/cancelReview">
								<input type="hidden" name="reviewId" value="{$reviewAssignment->getReviewId()}">
								<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
								<input type="submit" value="{translate key="editor.article.cancelReview"}">
							</form>
						</div>
						<div class="rightAligned">
							<form method="post" action="{$pageUrl}/sectionEditor/enterReviewerRecommendation">
								<input type="hidden" name="reviewId" value="{$reviewAssignment->getReviewId()}">
								<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
								<input type="submit" value="{translate key="editor.article.enterRecommendation"}">
							</form>
						</div>
					{elseif $reviewAssignment->getDateInitiated() and $reviewAssignment->getCancelled()}
						<div class="leftAligned">
							<form method="post" action="{$pageUrl}/sectionEditor/reinitiateReview">
								<input type="hidden" name="reviewId" value="{$reviewAssignment->getReviewId()}">
								<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
								<input type="submit" value="{translate key="editor.article.reinitiateReview"}">
							</form>
						</div>
						<div class="rightAligned">
							<form method="post" action="{$pageUrl}/sectionEditor/cancelReview">
								<input type="hidden" name="reviewId" value="{$reviewAssignment->getReviewId()}">
								<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
								<input type="submit" value="{translate key="editor.article.cancelReview"}" disabled="disabled">
							</form>
						</div>
						<div class="rightAligned">
							<form method="post" action="{$pageUrl}/sectionEditor/enterReviewerRecommendation">
								<input type="hidden" name="reviewId" value="{$reviewAssignment->getReviewId()}">
								<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
								<input type="submit" value="{translate key="editor.article.enterRecommendation"}" disabled="disabled">
							</form>
						</div>
					{/if}
				</td>
			</tr>
		</table>
	</td>
</tr>
<tr class="reviewDivider">
	<td></td>
</tr>
{/foreach}
{section name="selectReviewer" start=0 loop=$numSelectReviewers}
<tr class="submissionRowAlt">
	<td class="submissionBox">
		<span class="boldText">{$smarty.section.selectReviewer.index+$numReviewAssignments+$start|chr}.</span>
		<span class="disabledText">{translate key="editor.article.noneSelected"}</span>
	</td>
</tr>
{/section}
{if $showPeerReviewOptions}
<tr class="reviewDivider">
	<td></td>
</tr>
<tr>
	<td width="100%">
		<table class="plainFormat" width="100%">
			<tr>
				<td class="label" valign="top">{translate key="editor.article.peerReviewOptions"}</td>
				<td valign="top">
					<div class="rightAligned">
						<form method="post" action="{$pageUrl}/sectionEditor/initiateAllReviews">
							<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
							<input type="submit" value="{translate key="editor.article.initiateAllReviews"}">
						</form>
					</div>
					<div class="rightAligned">
						<form method="post" action="{$pageUrl}/sectionEditor/selectReviewer/{$submission->getArticleId()}">
							<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
							<input type="submit" value="{translate key="editor.article.addReviewer"}">
						</form>
					</div>
				</td>
			</tr>
		</table>
	</td>
</tr>
{/if}
</table>
</div>
		
<br />

<a name="editorReview"></a>
<div class="tableContainer">
<table width="100%">
<tr class="heading">
	<td>{translate key="submission.editorReview"}</td>
</tr>
<tr class="submissionRowAlt">
	<td class="submissionBox">
		<table class="plainFormat" width="100%">
			<tr>
				<td>
					<span class="boldText">{translate key="user.role.editor"}:</span>
					{if $editor}
						{$editor->getEditorFullName()}
					{else}
						{translate key="editor.article.noEditorSelected"}
					{/if}	
				</td>
			</tr>
		</table>
	</td>
</tr>
<tr class="submissionRow">
	<td class="submissionBox">
		<table class="plainFormat" width="100%">
			<tr>
				<td class="reviewLabel" valign="top">
					<span class="boldText">{translate key="editor.article.decision"}</span>
				</td>
				<td colspan="5">
					{foreach from=$submission->getDecisions($round) item=editorDecision key=decisionKey}
						{if $decisionKey neq 0} | {/if}
						{assign var="decision" value=$editorDecision.decision}
						<span class="boldTextAlt">{translate key=$editorDecisionOptions.$decision}</span>
						{$editorDecision.dateDecided|date_format:$dateFormatShort}
					{foreachelse}
						{translate key="common.none"}
					{/foreach}
				</td>
			</tr>
			<tr>
				<td></td>
				<td colspan="5">
					<div class="indented">
						<form method="post" action="{$pageUrl}/sectionEditor/recordDecision">
							<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
							<select name="decision" {if not $allowRecommendation}disabled="disabled"{/if}>
								{html_options_translate options=$editorDecisionOptions selected=$lastDecision}
							</select>
							<input type="submit" name="submit" value="{translate key="editor.article.recordDecision"}" {if not $allowRecommendation}disabled="disabled"{/if}>
						</form>
					</div>		
				</td>
			</tr>
			<tr>
				<td class="reviewLabel">
					<form method="post" action="{$pageUrl}/sectionEditor/notifyAuthor">
						<input type="hidden" name="articleId" value="{$submission->getArticleId()}">
						<span class="boldText">{translate key="editor.article.toAuthor"}</span><input type="image" src="{$baseUrl}/templates/images/mail.gif">
					</form>
				</td>
				<td colspan="5">
				</td>
			</tr>
			<form method="post" action="{$pageUrl}/editor/editorReview" enctype="multipart/form-data">
				<tr>
					<td></td>
					<td></td>
					<td></td>
					<td align="center"><span class="boldText">Comment</span></td>
					<td align="center">
						<input type="submit" name="setCopyeditFile" value="Send to Copyedit" {if not $allowCopyedit}disabled="disabled"{/if}>
					</td>
					<td align="center">
						<input type="submit" name="resubmit" value="Resubmit" {if not $allowResubmit}disabled="disabled"{/if}>
					</td>
				</tr>
				{foreach from=$submission->getEditorFileRevisions($round) item=editorFile key=key}
					<tr>
						<td class="reviewLabel" valign="top">
							{if $key eq 0}
								<span class="boldText">{translate key="submission.editorVersion"}</span>
							{/if}
						</td>
						<td><nobr><a href="{$pageUrl}/sectionEditor/downloadFile/{$editorFile->getFileId()}" class="file">{$editorFile->getFileName()}</a></nobr></td>
						<td>{$editorFile->getDateModified()|date_format:$dateFormatShort}</td>
						<td align="center"> - </td>
						<td align="center">
							<input type="radio" name="copyeditFile" value="{$editorFile->getFileId()},{$editorFile->getRevision()}" {if not $allowCopyedit}disabled="disabled"{/if}>
						</td>
						<td align="center">
							<input type="radio" name="resubmitFile" value="{$editorFile->getFileId()},{$editorFile->getRevision()}" {if not $allowResubmit}disabled="disabled"{/if}>
						</td>
					</tr>
				{foreachelse}
					<tr>
						<td class="reviewLabel" valign="top">
							<span class="boldText">{translate key="submission.editorVersion"}</span>
						</td>
						<td colspan="5"></td>
					</tr>
				{/foreach}
				<tr>
					<td></td>
					<td colspan="5">
						<div class="indented">
							<input type="hidden" name="articleId" value="{$submission->getArticleId()}" />
							<input type="file" name="upload">
							<input type="submit" name="submit" value="{translate key="common.upload"}">
						</div>
					</td>
				</tr>
				{foreach from=$submission->getAuthorFileRevisions($round) item=authorFile key=key}
					<tr>
						<td class="reviewLabel" valign="top">
							{if $key eq 0}
								<span class="boldText">{translate key="submission.authorVersion"}</span>
							{/if}
						</td>
						<td><nobr><a href="{$pageUrl}/sectionEditor/downloadFile/{$authorFile->getFileId()}" class="file">{$authorFile->getFileName()}</a></nobr></td>
						<td>{$authorFile->getDateModified()|date_format:$dateFormatShort}</td>
						<td align="center"> - </td>
						<td align="center">
							<input type="radio" name="copyeditFile" value="{$authorFile->getFileId()},{$authorFile->getRevision()}" {if not $allowCopyedit}disabled="disabled"{/if}>
						</td>
						<td align="center">
							<input type="radio" name="resubmitFile" value="{$authorFile->getFileId()},{$authorFile->getRevision()}" {if not $allowResubmit}disabled="disabled"{/if}>
						</td>
					</tr>
				{foreachelse}
					<tr>
						<td class="reviewLabel" valign="top">
							<span class="boldText">{translate key="submission.authorVersion"}</span>
						</td>
						<td colspan="5"></td>
					</tr>
				{/foreach}
			</form>
		</table>
	</td>
</tr>
</table>
</div>

{include file="common/footer.tpl"}
