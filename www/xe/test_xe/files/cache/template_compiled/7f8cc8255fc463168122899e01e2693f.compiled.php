<?php if(!defined("__XE__"))exit;
if($__Context->XE_VALIDATOR_MESSAGE && $__Context->XE_VALIDATOR_ID == 'modules/module/tpl/skin_config/1'){ ?><div class="message <?php echo $__Context->XE_VALIDATOR_MESSAGE_TYPE ?>">
	<p><?php echo $__Context->XE_VALIDATOR_MESSAGE ?></p>
</div><?php } ?>
<form action="./" method="post" enctype="multipart/form-data" class="x_form-horizontal"><input type="hidden" name="error_return_url" value="<?php echo htmlspecialchars(getRequestUriByServerEnviroment(), ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?>" />
	<input type="hidden" name="module" value="module" />
	<input type="hidden" name="vid" value="<?php echo $__Context->vid ?>" />
	<input type="hidden" name="mid" value="<?php echo $__Context->mid ?>" />
	<input type="hidden" name="act" value="procModuleAdminUpdateSkinInfo" />
	<input type="hidden" name="_mode" value="<?php echo $__Context->mode ?>" />
	<input type="hidden" name="module_srl" value="<?php echo $__Context->module_info->module_srl ?>" />
	<input type="hidden" name="page" value="<?php echo $__Context->page ?>" />
	<input type="hidden" name="xe_validator_id" value="modules/module/tpl/skin_config/1" />
	<section class="section">
		<h1><?php echo $__Context->lang->skin_default_info ?></h1>
		<div class="x_control-group">
			<label class="x_control-label">
				<?php echo $__Context->lang->skin ?>
			</label>
			<div class="x_controls" style="padding-top:3px">
				<?php echo $__Context->skin_info->title ?>
			</div>
		</div>
		<div class="x_control-group">
			<label class="x_control-label">
				<?php echo $__Context->lang->skin_author ?>
			</label>
			<div class="x_controls" style="padding-top:3px">
				<?php if($__Context->skin_info->author&&count($__Context->skin_info->author))foreach($__Context->skin_info->author as $__Context->author){ ?>
					<?php echo $__Context->author->name ?>
					<?php if($__Context->author->homepage || $__Context->author->email_address){ ?>
						(<?php if($__Context->author->homepage){ ?><a href="<?php echo $__Context->author->homepage ?>" target="_blank"><?php echo $__Context->author->homepage ?></a><?php } ?>
						<?php if($__Context->author->homepage && $__Context->author->email_address){ ?>, <?php } ?>
						<?php if($__Context->author->email_address){ ?><a href="mailto:<?php echo $__Context->author->email_address ?>"><?php echo $__Context->author->email_address ?></a><?php } ?>)
					<?php } ?><br />
				<?php } ?>
			</div>
		</div>
		<?php if($__Context->skin_info->homepage){ ?><div class="x_control-group">
			<label class="x_control-label"><?php echo $__Context->lang->homepage ?></label>
			<div class="x_controls" style="padding-top:3px"><a href="<?php echo $__Context->skin_info->homepage ?>" target="_blank"><?php echo $__Context->skin_info->homepage ?></a></div>
		</div><?php } ?>
		<div class="x_control-group">
			<label class="x_control-label"><?php echo $__Context->lang->date ?></label>
			<div class="x_controls" style="padding-top:3px"><?php echo zdate($__Context->skin_info->date, 'Y-m-d') ?></div>
		</div>
		<?php if($__Context->skin_info->license || $__Context->skin_info->license_link){ ?><div class="x_control-group">
			<label class="x_control-label"><?php echo $__Context->lang->skin_license ?></label>
			<div class="x_controls" style="padding-top:3px">
				<?php echo nl2br(trim($__Context->skin_info->license)) ?>
				<?php if($__Context->skin_info->license_link){ ?><p><a href="<?php echo $__Context->skin_info->license_link ?>" target="_blank"><?php echo $__Context->skin_info->license_link ?></a></p><?php } ?>
			</div>
		</div><?php } ?>
		<?php if($__Context->skin_info->description){ ?><div class="x_control-group">
			<label class="x_control-label"><?php echo $__Context->lang->description ?></label>
			<div class="x_controls" style="padding-top:3px"><?php echo nl2br(trim($__Context->skin_info->description)) ?></div>
		</div><?php } ?>
	</section>
	<?php if(count($__Context->skin_info->extra_vars) > 0){ ?>
	<section class="section">
		<h1><?php echo $__Context->lang->extra_vars ?></h1>
		<?php if($__Context->skin_info->colorset){ ?><div class="x_control-group">
			<label class="x_control-label"><?php echo $__Context->lang->colorset ?></label>
			<div class="x_controls">
				<?php if($__Context->skin_info->colorset&&count($__Context->skin_info->colorset))foreach($__Context->skin_info->colorset as $__Context->key=>$__Context->val){ ?>
					<?php if($__Context->val->screenshot){ ?>
					<?php  $__Context->_img_info = getImageSize($__Context->val->screenshot); $__Context->_height = $__Context->_img_info[1]+40; $__Context->_width = $__Context->_img_info[0]+20; $__Context->_talign = "center";  ?>
					<?php }else{ ?>
					<?php  $__Context->_width = 200; $__Context->_height = 20; $__Context->_talign = "left";  ?>
					<?php } ?>
					<div<?php if($__Context->val->screenshot){ ?> class="x_thumbnail"<?php } ?> style="display:inline-block;width:<?php echo $__Context->_width ?>px;margin-right:10px;">
						<label for="colorset_<?php echo $__Context->key ?>">
							<input type="radio" name="colorset" value="<?php echo $__Context->val->name ?>" id="colorset_<?php echo $__Context->key ?>"<?php if($__Context->skin_vars['colorset']->value==$__Context->val->name){ ?> checked="checked"<?php } ?> />
							<?php echo $__Context->val->title ?>
						</label>
						<?php if($__Context->val->screenshot){ ?><img src="/xe/test_xe/<?php echo $__Context->val->screenshot ?>" alt="<?php echo $__Context->val->title ?>" /><?php } ?>
					</div>
				<?php } ?>
			</div>
		</div><?php } ?>
		<?php if($__Context->skin_info->extra_vars&&count($__Context->skin_info->extra_vars))foreach($__Context->skin_info->extra_vars as $__Context->key=>$__Context->val){ ?>
			<?php if($__Context->val->group && ((!$__Context->group) || $__Context->group != $__Context->val->group)){ ?>
				<?php $__Context->group = $__Context->val->group ?>
				</section>
				<section class="section">
					<h2><?php echo $__Context->group ?></h2>
			<?php } ?>
			<div class="x_control-group">
				<label class="x_control-label"<?php if($__Context->val->type!='text'&&$__Context->val->type!='textarea'){ ?> for="<?php echo $__Context->val->name ?>"<?php };
if($__Context->val->type=='text'||$__Context->val->type=='textarea'){ ?> for="lang_<?php echo $__Context->val->name ?>"<?php } ?>><?php echo $__Context->val->title ?></label>
				<div class="x_controls">
					
					<?php if($__Context->val->type == 'text'){ ?><input type="text" name="<?php echo $__Context->val->name ?>" id="<?php echo $__Context->val->name ?>" value="<?php if(strpos($__Context->val->value, '$user_lang->') === false){;
echo $__Context->val->value;
}else{;
echo htmlspecialchars($__Context->val->value, ENT_COMPAT | ENT_HTML401, 'UTF-8', false);
} ?>" class="lang_code" /><?php } ?>
					
					<?php if($__Context->val->type == 'textarea'){ ?><textarea rows="8" cols="42" name="<?php echo $__Context->val->name ?>" id="<?php echo $__Context->val->name ?>" class="lang_code"><?php if(strpos($__Context->val->value, '$user_lang->') === false){;
echo $__Context->val->value;
}else{;
echo htmlspecialchars($__Context->val->value, ENT_COMPAT | ENT_HTML401, 'UTF-8', false);
} ?></textarea><?php } ?>
					
					<?php if($__Context->val->type == 'select'){ ?><select name="<?php echo $__Context->val->name ?>" id="<?php echo $__Context->val->name ?>">
						<?php if($__Context->val->options&&count($__Context->val->options))foreach($__Context->val->options as $__Context->k=>$__Context->v){ ?><option value="<?php echo $__Context->v->value ?>"<?php if($__Context->v->value == $__Context->val->value){ ?> selected="selected"<?php } ?>><?php echo $__Context->v->title ?></option><?php } ?>
					</select><?php } ?>
					
					<?php if($__Context->val->type == 'checkbox'){;
if($__Context->val->options&&count($__Context->val->options))foreach($__Context->val->options as $__Context->k=>$__Context->v){ ?><label for="ch_<?php echo $__Context->key ?>_<?php echo $__Context->k ?>" class="x_inline"><input type="checkbox" name="<?php echo $__Context->val->name ?>[]" value="<?php echo $__Context->v->value ?>" id="ch_<?php echo $__Context->key ?>_<?php echo $__Context->k ?>"<?php if(@in_array($__Context->v->value, $__Context->val->value)){ ?> checked="checked"<?php } ?> class="checkbox" /> <?php echo $__Context->v->title ?></label><?php }} ?>
					
					<?php if($__Context->val->type == 'radio'){;
if($__Context->val->options&&count($__Context->val->options))foreach($__Context->val->options as $__Context->k=>$__Context->v){ ?><label for="ch_<?php echo $__Context->key ?>_<?php echo $__Context->k ?>" class="x_inline"><input type="radio" name="<?php echo $__Context->val->name ?>" value="<?php echo $__Context->v->value ?>" id="ch_<?php echo $__Context->key ?>_<?php echo $__Context->k ?>"<?php if($__Context->v->value==$__Context->val->value){ ?> checked="checked"<?php } ?> /> <?php echo $__Context->v->title ?></label><?php }} ?>
					
					<?php if($__Context->val->type == 'image'){ ?>
						<?php if($__Context->val->value){ ?><div class="x_thumbnail" style="max-width:210px;margin:0 0 10px 0">
							<img src="<?php echo $__Context->val->value ?>" />
							<label for="del_<?php echo $__Context->val->name ?>" style="padding:8px 0 0 0"><input type="checkbox" name="del_<?php echo $__Context->val->name ?>" value="Y" id="del_<?php echo $__Context->val->name ?>" class="checkbox" /> <?php echo $__Context->lang->cmd_delete ?></label>
						</div><?php } ?>
						<input type="file" name="<?php echo $__Context->val->name ?>" value="" />
					<?php } ?>
					
					<?php if($__Context->val->type == 'colorpicker'){ ?><div>
						<?php  $__Context->use_colorpicker = true;  ?>
						<input type="text" class="color-indicator" name="<?php echo $__Context->val->name ?>" id="<?php echo $__Context->val->name ?>" value="<?php echo $__Context->val->value ?>" />
						<p id="categoy_color_help" hidden style="margin:8px 0 0 0"><?php echo $__Context->lang->about_category_color ?></p>
					</div><?php } ?>
					<?php if($__Context->val->description){ ?><a href="#about_<?php echo $__Context->val->name ?>" data-toggle class="x_icon-question-sign"<?php if($__Context->val->type == 'textarea'){ ?> style="vertical-align:top;margin-top:5px"<?php } ?>><?php echo $__Context->lang->help ?></a><?php } ?>
					<?php if($__Context->val->description){ ?><p class="x_help-block" id="about_<?php echo $__Context->val->name ?>" hidden><?php echo nl2br(trim($__Context->val->description)) ?></p><?php } ?>
				</div>
			</div>
		<?php } ?>
	</section>
	<?php } ?>
	<div class="btnArea">
		<button class="x_btn x_btn-primary x_pull-right" type="submit"><?php echo $__Context->lang->cmd_registration ?></button>
	</div>
</form>
<?php if($__Context->use_colorpicker){ ?>
	<!--#JSPLUGIN:ui.colorpicker--><?php Context::loadJavascriptPlugin('ui.colorpicker'); ?>
<?php } ?>
