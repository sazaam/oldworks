<?php if(!defined("__XE__"))exit;?><!--#Meta:modules/page/tpl/js/page_admin.js--><?php $__tmp=array('modules/page/tpl/js/page_admin.js','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<form action="./" method="post" onsubmit="return procFilter(this, insert_article)" id="fo_write"><input type="hidden" name="error_return_url" value="<?php echo htmlspecialchars(getRequestUriByServerEnviroment(), ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?>" /><input type="hidden" name="act" value="<?php echo $__Context->act ?>" /><input type="hidden" name="vid" value="<?php echo $__Context->vid ?>" />
	<input type="hidden" name="mid" value="<?php echo $__Context->mid ?>" />
	<input type="hidden" name="content" value="<?php echo $__Context->oDocument->getContentText() ?>" />
	<input type="hidden" name="document_srl" value="<?php echo $__Context->document_srl ?>" />
	<input type="hidden" name="isMobile" value="<?php echo $__Context->isMobile ?>" />
	<div style="margin-right:10px">
		<input type="text" name="title" value="<?php echo htmlspecialchars($__Context->oDocument->getTitleText(), ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?>" title="<?php echo $__Context->lang->title ?>" style="width:100%" />
	</div>
    <div class="editor"><?php echo $__Context->oDocument->getEditor() ?></div>
    <div class="tag">
        <input type="text" name="tags" value="<?php echo htmlspecialchars($__Context->oDocument->get('tags'), ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?>" class="iText" title="Tag" />
		<p><?php echo $__Context->lang->about_tag ?></p>
    </div>
	<div class="btnArea">
        <?php if($__Context->is_logged){ ?>
		<?php if(!$__Context->oDocument->isExists() || $__Context->oDocument->get('status') == 'TEMP'){ ?>
        <button class="btn" type="button" onclick="doDocumentSave(this);"><?php echo $__Context->lang->cmd_temp_save ?></button>
        <button class="btn" type="button" onclick="doDocumentLoad(this);"><?php echo $__Context->lang->cmd_load ?></button>
		<?php } ?>
        <?php } ?>
		<input class="btn" type="submit" value="<?php echo $__Context->lang->cmd_registration ?>" />
	</div>
</form>
