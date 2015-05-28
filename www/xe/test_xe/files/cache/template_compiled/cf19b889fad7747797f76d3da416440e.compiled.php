<?php if(!defined("__XE__"))exit;
$__tpl=TemplateHandler::getInstance();echo $__tpl->compile('modules/module/tpl','header.html') ?>
<?php if($__Context->XE_VALIDATOR_MESSAGE && $__Context->XE_VALIDATOR_ID == 'modules/autoinstall/tpl/uninstall/1'){ ?><div class="message <?php echo $__Context->XE_VALIDATOR_MESSAGE_TYPE ?>">
	<p><?php echo $__Context->XE_VALIDATOR_MESSAGE ?></p>
</div><?php } ?>
<table class="x_table x_table-striped x_table-hover">
	<caption>
		<strong>All(<?php echo count($__Context->module_list) ?>)</strong>
	</caption>
	<thead>
		<tr>
			<th class="nowr"><?php echo $__Context->lang->favorite ?></th>
			<th class="title"><?php echo $__Context->lang->module_name ?></th>
			<th class="nowr"><?php echo $__Context->lang->version ?></th>
			<th class="nowr"><?php echo $__Context->lang->author ?></th>
			<th class="nowr"><?php echo $__Context->lang->path ?></th>
			<th class="nowr"><?php echo $__Context->lang->cmd_delete ?></th>
		</tr>
	</thead>
	<tbody>
		<?php if($__Context->module_list&&count($__Context->module_list))foreach($__Context->module_list as $__Context->key=>$__Context->val){ ?><tr<?php if(in_array($__Context->val->module,$__Context->favoriteModuleList)){ ?> data-type1="#"<?php };
if($__Context->val->need_install || $__Context->val->need_update || $__Context->val->need_autoinstall_update){ ?> data-type2="#"<?php } ?>>
			<td>
				<?php if(in_array($__Context->val->module,$__Context->favoriteModuleList)){ ?><button type="button" class="fvOn" onclick="doToggleFavoriteModule(this, '<?php echo $__Context->val->module ?>')"><?php echo $__Context->lang->favorite ?>(<?php echo $__Context->lang->on ?>)</button><?php } ?>
				<?php if(!in_array($__Context->val->module,$__Context->favoriteModuleList)){ ?><button type="button" class="fvOff" onclick="doToggleFavoriteModule(this, '<?php echo $__Context->val->module ?>')"><?php echo $__Context->lang->favorite ?>(<?php echo $__Context->lang->off ?>)</button><?php } ?>
			</td>
			<td class="title">
				<p>
					<?php if($__Context->val->admin_index_act){ ?><a href="<?php echo getUrl('','module','admin','act',$__Context->val->admin_index_act) ?>"><?php echo $__Context->val->title ?></a><?php } ?>
					<?php if(!$__Context->val->admin_index_act){ ?><strong><?php echo $__Context->val->title ?></strong><?php } ?>
				</p>
				<p><?php echo $__Context->val->description ?></p>
				<?php if($__Context->val->need_install){ ?><p class="x_alert x_alert-info"><?php echo $__Context->lang->msg_avail_install ?> <button class="text" type="button" onclick="doInstallModule('<?php echo $__Context->val->module ?>')"><?php echo $__Context->lang->msg_do_you_like_install ?></button></p><?php } ?>
				<?php if($__Context->val->need_update){ ?><p class="x_alert x_alert-info"><?php echo $__Context->lang->msg_avail_update ?> <button class="text" type="button" onclick="doUpdateModule('<?php echo $__Context->val->module ?>')"><?php echo $__Context->lang->msg_do_you_like_update ?></button></p><?php } ?>
				<?php if($__Context->val->need_autoinstall_update == 'Y'){ ?><p class="x_alert x_alert-info"><?php echo $__Context->lang->msg_avail_easy_update ?> <a href="<?php echo $__Context->val->update_url ?>&amp;return_url=<?php echo urlencode(getRequestUriByServerEnviroment()) ?>"><?php echo $__Context->lang->msg_do_you_like_update ?></a></p><?php } ?>
			</td>
			<td><?php echo $__Context->val->version ?></td>
			<td class="nowr">
				<?php if($__Context->val->author&&count($__Context->val->author))foreach($__Context->val->author as $__Context->author){ ?>
					<?php if($__Context->author->homepage){ ?>
						<a href="<?php echo $__Context->author->homepage ?>" target="_blank"><?php echo $__Context->author->name ?></a>
					<?php }else{ ?>
						<?php echo $__Context->author->name ?>
					<?php } ?>
				<?php } ?>
			</td>
			<td><?php echo $__Context->val->path ?></td>
			<td>
				<?php if($__Context->val->delete_url){ ?><a href="<?php echo $__Context->val->delete_url ?>&amp;return_url=<?php echo urlencode(getRequestUriByServerEnviroment()) ?>"><?php echo $__Context->lang->cmd_delete ?></a><?php } ?>
			</td>
		</tr><?php } ?>
	</tbody>
</table>
<style scoped>
.fvOff,
.fvOn{display:inline-block;width:16px;height:16px;overflow:hidden;text-indent:16px;background:transparent url(./modules/admin/tpl/img/iconFavorite.gif) no-repeat;border:0}
.fvOn{background-position:0 -16px}
</style>
<script>
jQuery(function($){
	$('.dsTg>tbody>tr[data-type1]').prependTo('tbody');
	$('.dsTg>tbody>tr[data-type2]').prependTo('tbody');
});
</script>