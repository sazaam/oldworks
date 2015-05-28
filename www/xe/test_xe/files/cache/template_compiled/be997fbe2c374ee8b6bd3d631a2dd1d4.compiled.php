<?php if(!defined("__XE__"))exit;?><div class="x_page-header">
	<h1>
		<?php echo $__Context->lang->installed_widgets ?> <a class="x_icon-question-sign" href="./admin/help/index.html#UMAN_advanced_installed_widget" target="_blank"><?php echo $__Context->lang->help ?></a>
		<?php if($__Context->widget_info){ ?><span class="path">
			&gt; <?php echo $__Context->widget_info->title ?> <?php if($__Context->widget_info){ ?><a href="#widgetInfo" class="x_icon-question-sign" data-toggle><?php echo $__Context->lang->help ?></a><?php } ?> 
		</span><?php } ?>
		<?php if($__Context->widget_info){ ?><span class="path">
			&gt; <?php echo $__Context->lang->cmd_generate_code ?> <a href="#codeHelp" class="x_icon-question-sign" data-toggle style="vertical-align:middle"><?php echo $__Context->lang->help ?></a>
		</span><?php } ?>
	</h1>
</div>
<?php if($__Context->XE_VALIDATOR_MESSAGE && $__Context->XE_VALIDATOR_ID == 'modules/autoinstall/tpl/uninstall/1'){ ?><div class="message <?php echo $__Context->XE_VALIDATOR_MESSAGE_TYPE ?>">
	<p><?php echo $__Context->XE_VALIDATOR_MESSAGE ?></p>
</div><?php } ?>
