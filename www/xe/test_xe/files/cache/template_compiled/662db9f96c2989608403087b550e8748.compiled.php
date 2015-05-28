<?php if(!defined("__XE__"))exit;?>
<?php if($__Context->colorset=="black"){ ?>
    <!--#Meta:widgets/login_info/skins/xe_official/css/black.css--><?php $__tmp=array('widgets/login_info/skins/xe_official/css/black.css','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<?php }elseif($__Context->colorset=="white"){ ?>
    <!--#Meta:widgets/login_info/skins/xe_official/css/white.css--><?php $__tmp=array('widgets/login_info/skins/xe_official/css/white.css','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<?php }else{ ?>
    <!--#Meta:widgets/login_info/skins/xe_official/css/default.css--><?php $__tmp=array('widgets/login_info/skins/xe_official/css/default.css','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<?php } ?>
<?php require_once('./classes/xml/XmlJsFilter.class.php');$__xmlFilter=new XmlJsFilter('widgets/login_info/skins/xe_official/filter','login.xml');$__xmlFilter->compile(); ?>
<?php require_once('./classes/xml/XmlJsFilter.class.php');$__xmlFilter=new XmlJsFilter('widgets/login_info/skins/xe_official/filter','openid_login.xml');$__xmlFilter->compile(); ?>
<!--#Meta:widgets/login_info/skins/xe_official/js/login.js--><?php $__tmp=array('widgets/login_info/skins/xe_official/js/login.js','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<?php if($__Context->XE_VALIDATOR_MESSAGE && $__Context->XE_VALIDATOR_ID == 'widgets/login_info/skins/xe_official/login_form/1'){ ?><div class="message <?php echo $__Context->XE_VALIDATOR_MESSAGE_TYPE ?>">
	<p><?php echo $__Context->XE_VALIDATOR_MESSAGE ?></p>
</div><?php } ?>
<?php Context::addJsFile("./files/ruleset/login.xml", FALSE, "", 0, "body", TRUE, "") ?><form id="fo_login_widget" action="<?php echo getUrl('','act','procMemberLogin') ?>" method="post"  class="login_<?php echo $__Context->colorset ?>"><input type="hidden" name="error_return_url" value="<?php echo htmlspecialchars(getRequestUriByServerEnviroment(), ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?>" /><input type="hidden" name="mid" value="<?php echo $__Context->mid ?>" /><input type="hidden" name="vid" value="<?php echo $__Context->vid ?>" /><input type="hidden" name="ruleset" value="@login" />
	<fieldset>
		<input type="hidden" name="act" value="procMemberLogin" />
		<input type="hidden" name="success_return_url" value="<?php echo htmlspecialchars(getRequestUriByServerEnviroment(), ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?>" />
		<input type="hidden" name="xe_validator_id" value="widgets/login_info/skins/xe_official/login_form/1" />
		<div class="idpwWrap">
			<div class="idpw">
				<input name="user_id" type="text" title="<?php if($__Context->member_config->identifier != 'email_address'){;
echo $__Context->lang->user_id;
}else{;
echo $__Context->lang->email_address;
} ?>" />
				<input name="password" type="password" title="<?php echo $__Context->lang->password ?>" />
				<p class="keep">
					<input type="checkbox" name="keep_signed" id="keep_signed" value="Y" />
					<label for="keep_signed"><?php echo $__Context->lang->keep_signed ?></label>
				</p>
			</div>
			<?php if($__Context->colorset){ ?><input type="image" src="/xe/test_xe/widgets/login_info/skins/xe_official/images/<?php echo $__Context->colorset ?>/buttonLogin.gif" alt="login" class="login" /><?php } ?>
			<?php if(!$__Context->colorset){ ?><input type="submit" class="login" value="<?php echo $__Context->lang->cmd_login ?>" /><?php } ?>
		</div>
		<?php if($__Context->ssl_mode){ ?><p class="securitySignIn <?php if($__Context->ssl_mode){ ?>SSL<?php }else{ ?>noneSSL<?php } ?>">
			<button type="button" class="text" onclick="toggleSecuritySignIn(); return false;"><?php echo $__Context->lang->security_sign_in ?></button>
		</p><?php } ?>
		<p class="keep_msg"><?php echo $__Context->lang->about_keep_warning ?></p>
		<ul class="help">
			<li><a href="<?php echo getUrl('act','dispMemberSignUpForm') ?>"><?php echo $__Context->lang->cmd_signup ?></a></li>
			<li><a href="<?php echo getUrl('act','dispMemberFindAccount') ?>"><?php echo $__Context->lang->cmd_find_member_account ?></a></li>
		</ul>
	</fieldset>
</form> 
