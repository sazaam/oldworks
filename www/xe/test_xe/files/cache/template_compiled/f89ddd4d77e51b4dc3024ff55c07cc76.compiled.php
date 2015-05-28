<?php if(!defined("__XE__"))exit;
$__tpl=TemplateHandler::getInstance();echo $__tpl->compile('modules/admin/tpl','_header.html') ?>
<!--#Meta:modules/admin/tpl/js/excanvas.min.js--><?php $__tmp=array('modules/admin/tpl/js/excanvas.min.js','','lt IE 9','');Context::loadFile($__tmp);unset($__tmp); ?>
<!--#Meta:modules/admin/tpl/js/jquery.jqplot.min.js--><?php $__tmp=array('modules/admin/tpl/js/jquery.jqplot.min.js','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<!--#Meta:modules/admin/tpl/js/jqplot.barRenderer.min.js--><?php $__tmp=array('modules/admin/tpl/js/jqplot.barRenderer.min.js','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<!--#Meta:modules/admin/tpl/js/jqplot.categoryAxisRenderer.min.js--><?php $__tmp=array('modules/admin/tpl/js/jqplot.categoryAxisRenderer.min.js','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<!--#Meta:modules/admin/tpl/js/jqplot.pointLabels.min.js--><?php $__tmp=array('modules/admin/tpl/js/jqplot.pointLabels.min.js','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<!--#Meta:modules/admin/tpl/css/jquery.jqplot.min.css--><?php $__tmp=array('modules/admin/tpl/css/jquery.jqplot.min.css','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<div class="content" id="content">
	<div class="x_page-header">
		<h1><?php echo $__Context->lang->control_panel ?> <a class="x_icon-question-sign" href="./admin/help/index.html#UMAN_dashboard" target="_blank"><?php echo $__Context->lang->help ?></a></h1>
	</div>
	<div id="checkBrowserMessage" class="message error" style="display:none;">
		<h2><?php echo $__Context->lang->checkBrowserIE8 ?></h2>
	</div>
	<?php if($__Context->XE_VALIDATOR_MESSAGE && $__Context->XE_VALIDATOR_ID == 'modules/admin/tpl/index/1'){ ?><div class="message <?php echo $__Context->XE_VALIDATOR_MESSAGE_TYPE ?>">
		<p><?php echo $__Context->XE_VALIDATOR_MESSAGE ?></p>
	</div><?php } ?>
	<?php if(!$__Context->isEnviromentGatheringAgreement){ ?><form action="./" method="post" class="message info x_clearfix"><input type="hidden" name="error_return_url" value="<?php echo htmlspecialchars(getRequestUriByServerEnviroment(), ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?>" /><input type="hidden" name="mid" value="<?php echo $__Context->mid ?>" /><input type="hidden" name="vid" value="<?php echo $__Context->vid ?>" />
		<input type="hidden" name="module" value="admin" />
		<input type="hidden" name="act" value="procAdminEnviromentGatheringAgreement" />
		<input type="hidden" name="xe_validator_id" value="modules/admin/tpl/index/1" />
		<h2><?php echo $__Context->lang->install_env_agreement ?></h2>
		<p><?php echo $__Context->lang->install_env_agreement_desc ?></p>
		<div class="x_btn-group x_pull-right" style="margin-bottom:10px">
			<button type="submit" name="is_agree" value="false" class="x_btn x_btn-small"><?php echo $__Context->lang->disagree ?></button>
			<button type="submit" name="is_agree" value="true" class="x_btn x_btn-small x_btn-primary"><?php echo $__Context->lang->agree ?></button>
		</div>
	</form><?php } ?>
	<?php if($__Context->addTables || $__Context->needUpdate){ ?><div class="message update">
		<?php if($__Context->needUpdate && $__Context->addTables){ ?><h2><?php echo $__Context->lang->need_update_and_table ?></h2><?php } ?>
		<?php if($__Context->needUpdate && !$__Context->addTables){ ?><h2><?php echo $__Context->lang->need_update ?></h2><?php } ?>
		<?php if(!$__Context->needUpdate && $__Context->addTables){ ?><h2><?php echo $__Context->lang->need_table ?></h2><?php } ?>
		<ul>
		<?php if($__Context->module_list&&count($__Context->module_list))foreach($__Context->module_list as $__Context->key=>$__Context->value){ ?>
			<?php if($__Context->value->need_install){ ?><li style="margin:0 0 4px 0"><?php echo $__Context->value->module ?> - <button type="button" onclick="doInstallModule('<?php echo $__Context->value->module ?>')" class="x_btn x_btn-small"><?php echo $__Context->lang->cmd_create_db_table ?></button></li><?php } ?>
			<?php if($__Context->value->need_update){ ?><li style="margin:0 0 4px 0"><?php echo $__Context->value->module ?> - <button type="button" onclick="doUpdateModule('<?php echo $__Context->value->module ?>')" class="x_btn x_btn-small"><?php echo $__Context->lang->cmd_module_update ?></button></li><?php } ?>
		<?php } ?>
		</ul>
	</div><?php } ?>
	<?php if(count($__Context->newVersionList)){ ?><div class="message update">
		<h2><?php echo $__Context->lang->available_new_version ?></h2>
		<ul>
			<?php if($__Context->newVersionList&&count($__Context->newVersionList))foreach($__Context->newVersionList as $__Context->key=>$__Context->package){ ?><li style="margin:0 0 4px 0">
				[<?php echo $__Context->lang->typename[$__Context->package->type] ?> <?php if($__Context->package->helpUrl){ ?><a class="x_icon-question-sign" href="<?php echo $__Context->package->helpUrl ?>" target="_blank"><?php echo $__Context->lang->help ?></a><?php } ?>] <?php echo $__Context->package->title ?> ver. <?php echo $__Context->package->version ?> - <a href="<?php echo $__Context->package->url ?>&amp;return_url=<?php echo urlencode(getRequestUriByServerEnviroment()) ?>"><?php echo $__Context->lang->update ?></a>
			</li><?php } ?>
		</ul>
	</div><?php } ?>
	
	<div class="dashboard">
		<div>
			<section class="status">
				<h2><?php echo $__Context->lang->uv ?></h2>
				<div style="margin:10px 15px;height:142px" id="visitors"></div>
				<div class="more">
					<dl>
						<dt><?php echo $__Context->lang->menu_gnb['user'] ?>: </dt><dd><a href="<?php echo getUrl('', 'module', 'admin', 'act', 'dispMemberAdminList') ?>"><?php echo number_format($__Context->status->member->totalCount) ?> (<?php if($__Context->status->member->todayCount > 0){ ?>+<?php };
echo number_format($__Context->status->member->todayCount) ?>)</a></dd>
					</dl>
					<a href="<?php echo getUrl('', 'module', 'admin', 'act', 'dispCounterAdminIndex') ?>"><i>&rsaquo;</i> <?php echo $__Context->lang->details ?></a>
				</div>
			</section>
			<section class="status">
				<h2><?php echo $__Context->lang->pv ?></h2>
				<div style="margin:10px 15px;height:142px" id="page_views"></div>
				<div class="more">
					<dl>
						<dt><?php echo $__Context->lang->menu_gnb_sub['document'] ?>: </dt><dd><a href="<?php echo getUrl('', 'module', 'admin', 'act', 'dispDocumentAdminList') ?>"><?php echo number_format($__Context->status->document->totalCount) ?> (<?php if($__Context->status->document->todayCount > 0){ ?>+<?php };
echo number_format($__Context->status->document->todayCount) ?>)</a></dd>
					</dl>
					<a href="<?php echo getUrl('', 'module', 'admin', 'act', 'dispCounterAdminIndex') ?>"><i>&rsaquo;</i> <?php echo $__Context->lang->details ?></a>
				</div>
			</section>
			<style scoped>.jqplot-table-legend{background:#fff;top:13px!important}</style>
		</div>
		<div>
			<section class="document">
				<h2><?php echo $__Context->lang->latest_documents ?></h2>
				<ul>
					<?php if($__Context->latestDocumentList&&count($__Context->latestDocumentList))foreach($__Context->latestDocumentList as $__Context->key=>$__Context->value){ ?><li>
						<?php $__Context->document = $__Context->value->variables ?>
						<a href="<?php echo getUrl('', 'document_srl', $__Context->document['document_srl']) ?>" target="_blank"><?php if(trim($__Context->value->getTitle())){;
echo $__Context->value->getTitle();
}else{ ?><strong><?php echo $__Context->lang->no_title_document ?></strong><?php } ?></a> 
						<span class="side"><?php echo $__Context->value->getNickName() ?></span>
						<form class="action" method="POST"><input type="hidden" name="error_return_url" value="<?php echo htmlspecialchars(getRequestUriByServerEnviroment(), ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?>" /><input type="hidden" name="mid" value="<?php echo $__Context->mid ?>" /><input type="hidden" name="vid" value="<?php echo $__Context->vid ?>" />
							<input type="hidden" name="module" value="admin" />
							<input type="hidden" name="act" value="procDocumentManageCheckedDocument" />
							<input type="hidden" name="cart[]" value="<?php echo $__Context->document['document_srl'] ?>" />
							<input type="hidden" name="success_return_url" value="<?php echo getUrl('', 'module', 'admin') ?>" />
							<button type="submit" name="type" value="trash" class="x_icon-trash"><?php echo $__Context->lang->cmd_trash ?></button>
							<button type="submit" name="type" value="delete" class="x_icon-remove"><?php echo $__Context->lang->cmd_delete ?></button>
						</form>
					</li><?php } ?>
					<?php if(!is_array($__Context->latestDocumentList) || count($__Context->latestDocumentList) < 1){ ?><li><?php echo $__Context->lang->no_data ?></li><?php } ?>
				</ul>
				<p class="more"><a href="<?php echo getUrl('', 'module', 'admin', 'act', 'dispDocumentAdminList') ?>"><i>&rsaquo;</i> <?php echo $__Context->lang->more ?></a></p>
			</section>
			<section class="reply">
				<h2><?php echo $__Context->lang->latest_comments ?></h2>
				<ul>
					<?php if($__Context->latestCommentList&&count($__Context->latestCommentList))foreach($__Context->latestCommentList as $__Context->key=>$__Context->value){ ?><li>
						<a href="<?php echo getUrl('', 'document_srl', $__Context->value->document_srl) ?>#comment_<?php echo $__Context->value->comment_srl ?>" target="_blank"><?php if(trim($__Context->value->content)){;
echo $__Context->value->getSummary();
}else{ ?><strong><?php echo $__Context->lang->no_text_comment ?></strong><?php } ?></a> 
						<span class="side"><?php echo $__Context->value->getNickName() ?></span> 
						<form class="action"><input type="hidden" name="error_return_url" value="<?php echo htmlspecialchars(getRequestUriByServerEnviroment(), ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?>" /><input type="hidden" name="mid" value="<?php echo $__Context->mid ?>" /><input type="hidden" name="vid" value="<?php echo $__Context->vid ?>" />
							<input type="hidden" name="module" value="admin" />
							<input type="hidden" name="act" value="procCommentAdminDeleteChecked" />
							<input type="hidden" name="cart[]" value="<?php echo $__Context->value->comment_srl ?>" />
							<input type="hidden" name="success_return_url" value="<?php echo getUrl('', 'module', 'admin') ?>" />
							<button type="submit" name="is_trash" value="true" class="x_icon-trash"><?php echo $__Context->lang->cmd_trash ?></button>
							<button type="submit" name="is_trash" value="false" class="x_icon-remove"><?php echo $__Context->lang->cmd_delete ?></button>
						</form>
					</li><?php } ?>
					<?php if(!is_array($__Context->latestCommentList) || count($__Context->latestCommentList) < 1){ ?><li><?php echo $__Context->lang->no_data ?></li><?php } ?>
				</ul>
				<p class="more"><a href="<?php echo getUrl('', 'module', 'admin', 'act', 'dispCommentAdminList') ?>"><i>&rsaquo;</i> <?php echo $__Context->lang->more ?></a></p>
			</section>
		</div>
	</div>
</div>
<?php $__tpl=TemplateHandler::getInstance();echo $__tpl->compile('modules/admin/tpl','_footer.html') ?>
<script>
xe.lang.this_week = '<?php echo $__Context->lang->this_week ?>';
xe.lang.last_week = '<?php echo $__Context->lang->last_week ?>';
xe.lang.next_week = '<?php echo $__Context->lang->next_week ?>';
xe.lang.mon = '<?php echo $__Context->lang->mon ?>';
xe.lang.tue = '<?php echo $__Context->lang->tue ?>';
xe.lang.wed = '<?php echo $__Context->lang->wed ?>';
xe.lang.thu = '<?php echo $__Context->lang->thu ?>';
xe.lang.fri = '<?php echo $__Context->lang->fri ?>';
xe.lang.sat = '<?php echo $__Context->lang->sat ?>';
xe.lang.sun = '<?php echo $__Context->lang->sun ?>';
jQuery(function($)
{
	// Dashboard portlet UI
	$('.dashboard>div>section>ul>li')
	.bind('mouseenter focusin', function(){
		$(this).addClass('hover').find('>.action').show();
	})
	.bind('mouseleave focusout', function()
	{
		if(!$(this).find(':focus').length)
		{
			$(this).removeClass('hover').find('>.action').hide();
		}
	});
	// check browser version
	if($.browser.msie == true ) {
		var arrBrowserVersion = $.browser.version.split('.');
		if(parseInt(arrBrowserVersion[0]) <= 8) {
			$('#checkBrowserMessage').show();
		}
	}
});
function obj2Array(htObj)
{
	var aRes = [];
	for(var x in htObj)
	{
		if(!htObj.hasOwnProperty(x)) continue;
		aRes.push(htObj[x]);
	}
	return aRes;
}
jQuery(function ($)
{
	$.exec_json("counter.getWeeklyUniqueVisitor", {}, function(htRes)
	{
		var aLastWeek = obj2Array(htRes.last_week.list);
		var aThisWeek = obj2Array(htRes.this_week.list);
		drawChart("visitors", "Weekly Visitors", aLastWeek, aThisWeek);
	});
	$.exec_json("counter.getWeeklyPageView", {}, function(htRes)
	{
		var aLastWeek = obj2Array(htRes.last_week.list);
		var aThisWeek = obj2Array(htRes.this_week.list);
		drawChart("page_views", "Weekly Page Views", aLastWeek, aThisWeek);
	});
});
function drawChart(sContainerId, sTitle, aLastWeek, aThisWeek)
{
	$ = jQuery;
	var s1 = aLastWeek;
	var s2 = aThisWeek;
	// Can specify a custom tick Array.
	// Ticks should match up one for each y value (category) in the series.
	var ticks = [xe.lang.sun,xe.lang.mon,xe.lang.tue,xe.lang.wed,xe.lang.thu,xe.lang.fri,xe.lang.sat];
	var plot1 = $.jqplot(sContainerId, [s1, s2], {
		seriesDefaults:{
			renderer:$.jqplot.BarRenderer,
			rendererOptions: {fillToZero: true}
		},
		series:[
			{label: xe.lang.last_week},
			{label: xe.lang.this_week}
		],
		legend:
		{
			show: true,
			placement: 'outsideGrid'
		},
		axes: {
			xaxis: {
				renderer: $.jqplot.CategoryAxisRenderer, ticks: ticks
			},
			yaxis: {
				min: 0, ticks: 1, pad: 1.05
			}
		}
	});
};
</script>
