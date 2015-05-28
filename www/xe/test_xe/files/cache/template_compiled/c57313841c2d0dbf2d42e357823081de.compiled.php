<?php if(!defined("__XE__"))exit;?><div class="x_page-header">
	<h1><?php echo $__Context->lang->cmd_multilingual ?> <a class="x_icon-question-sign" href="./admin/help/index.html#UMAN_content_langcode" target="_blank"><?php echo $__Context->lang->help ?></a></h1>
</div>
<p><?php echo $__Context->lang->multilingual_desc ?></p>
<?php $__Context->use_in_page = true ?>
<?php $__tpl=TemplateHandler::getInstance();echo $__tpl->compile('modules/module/tpl','multilingual_v17.html') ?>
<script>
jQuery(function($){
	$('#g11n')
		.xeMultilingualWindow(
			{
				create_type: 'save',
				modify_type: 'save',
				view_delete: true,
				view_use: false,
				list_count: 10
			}
		)
		.trigger('before-open.g11n');
});
</script>
