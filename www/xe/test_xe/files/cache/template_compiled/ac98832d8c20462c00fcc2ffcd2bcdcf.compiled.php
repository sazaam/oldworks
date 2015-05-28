<?php if(!defined("__XE__"))exit;?><!--#Meta:common/js/jquery.min.js--><?php $__tmp=array('common/js/jquery.min.js','','','-1000000');Context::loadFile($__tmp);unset($__tmp); ?>
<?php if(!$__Context->is_logged && $__Context->module == 'admin'){ ?>
<!--#Meta:common/css/bootstrap.min.css--><?php $__tmp=array('common/css/bootstrap.min.css','','','1');Context::loadFile($__tmp);unset($__tmp); ?>
<?php } ?>
<?php require_once('./classes/xml/XmlJsFilter.class.php');$__xmlFilter=new XmlJsFilter('modules/message/skins/default/filter','openid_login.xml');$__xmlFilter->compile(); ?>
<!--#Meta:modules/message/skins/default/message.css--><?php $__tmp=array('modules/message/skins/default/message.css','','','2');Context::loadFile($__tmp);unset($__tmp); ?>
<!--#Meta:modules/message/skins/default/message.js--><?php $__tmp=array('modules/message/skins/default/message.js','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<div id="access">
	<div class="login-header">
		<h1><i class="icon-user"></i> <?php echo $__Context->system_message ?></h1>
	</div>
	<div class="login-body">
		<?php if($__Context->XE_VALIDATOR_MESSAGE && $__Context->XE_VALIDATOR_ID == 'modules/message/skins/default/system_message/1'){ ?><div class="message <?php echo $__Context->XE_VALIDATOR_MESSAGE_TYPE ?>">
			<p><?php echo $__Context->XE_VALIDATOR_MESSAGE ?></p>
		</div><?php } ?>
		<?php if(!$__Context->is_logged && $__Context->module == 'admin'){;
Context::addJsFile("./files/ruleset/login.xml", FALSE, "", 0, "body", TRUE, "") ?><form  action="<?php echo getUrl('','act','procMemberLogin') ?>" method="post"><input type="hidden" name="error_return_url" value="<?php echo htmlspecialchars(getRequestUriByServerEnviroment(), ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?>" /><input type="hidden" name="mid" value="<?php echo $__Context->mid ?>" /><input type="hidden" name="vid" value="<?php echo $__Context->vid ?>" /><input type="hidden" name="ruleset" value="@login" />
			<input type="hidden" name="module" value="member" />
			<input type="hidden" name="act" value="procMemberLogin" />
			<input type="hidden" name="success_return_url" value="<?php echo getRequestUriByServerEnviroment() ?>" />
			<input type="hidden" name="xe_validator_id" value="modules/message/skins/default/system_message/1" />
			<fieldset>
				<div class="control-group">
					<?php if($__Context->member_config->identifier != 'email_address'){ ?><input type="text" name="user_id" id="uid" title="<?php echo $__Context->lang->user_id ?>" placeholder="<?php echo $__Context->lang->user_id ?>" required autofocus /><?php } ?>
					<?php if($__Context->member_config->identifier == 'email_address'){ ?><input type="email" name="user_id" id="uid" title="<?php echo $__Context->lang->email_address ?>" placeholder="<?php echo $__Context->lang->email_address ?>" required autofocus /><?php } ?>
					<input type="password" name="password" id="upw" title="<?php echo $__Context->lang->password ?>" placeholder="<?php echo $__Context->lang->password ?>" required />
				</div>
				<div class="control-group">
					<label for="keepid">
						<input type="checkbox" name="keep_signed" id="keepid" class="inputCheck" value="Y" onclick="jQuery('#warning')[(jQuery('#keepid:checked').size()&gt;0?'addClass':'removeClass')]('open');" />						
						<?php echo $__Context->lang->keep_signed ?>
					</label>
					<p id="warning"><?php echo $__Context->lang->about_keep_warning ?></p>
					<input type="submit" value="<?php echo $__Context->lang->cmd_login ?>" class="submit btn btn-inverse" />
				</div>
			</fieldset>
		</form><?php } ?>
		<?php if($__Context->is_logged){ ?><p style="text-align:center">
			<a href="<?php echo getUrl('act','dispMemberLogout','module','') ?>" class="btn"><?php echo $__Context->lang->cmd_logout ?></a>
		</p><?php } ?>
		<?php if(!$__Context->is_logged && $__Context->module != 'admin'){ ?><p style="text-align:center">
			<a href="<?php echo getUrl('act','dispMemberLoginForm','module','', 'mid', '') ?>" class="btn"><?php echo $__Context->lang->cmd_login ?></a>
		</p><?php } ?>
	</div>
	<?php if(!$__Context->is_logged){ ?><div class="login-footer">
		<div class="pull-right">
			<a href="<?php echo getUrl('','act','dispMemberFindAccount') ?>"><?php echo $__Context->lang->cmd_find_member_account ?></a>
			|
			<a href="<?php echo getUrl('','act','dispMemberSignUpForm') ?>"><span><?php echo $__Context->lang->cmd_signup ?></span></a>
		</div>
	</div><?php } ?>
</div>
