<?php if(!defined("__XE__"))exit;?><meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=2, user-scalable=yes" />
<div class="x">
<p class="skipNav"><a href="#content"><?php echo $__Context->lang->skip_to_content ?></a></p>
	<header class="header">
		<h1>
			<a href="<?php echo getUrl('','module','admin') ?>"><img src="<?php echo getUrl('');
echo $__Context->gnb_title_info->adminLogo ?>" alt="<?php echo $__Context->gnb_title_info->adminTitle ?>" /> <?php echo $__Context->gnb_title_info->adminTitle ?></a>
		</h1>
		<p class="site"><a href="<?php echo getFullUrl('') ?>"><?php echo getFullUrl('') ?></a></p>
		<div class="account">
			<ul>
				<li><a href="<?php echo getUrl('', 'module', 'admin', 'act', 'dispMemberAdminInfo', 'is_admin', 'Y', 'member_srl', $__Context->logged_info->member_srl) ?>"><?php echo $__Context->logged_info->email_address ?></a></li>
				<li><a href="<?php echo getUrl('', 'module','admin','act','procAdminLogout') ?>"><?php echo $__Context->lang->cmd_logout ?></a></li>
				<li><a href="#lang" class="lang" data-toggle><?php echo $__Context->lang_supported[$__Context->lang_type] ?></a>
					<ul id="lang" class="x_dropdown-menu">
						<?php if($__Context->lang_supported&&count($__Context->lang_supported))foreach($__Context->lang_supported as $__Context->key=>$__Context->val){ ?><li<?php if($__Context->key==$__Context->lang_type){ ?> class="x_active"<?php } ?>><a href="<?php echo getUrl('l',$__Context->key) ?>" data-langcode="<?php echo $__Context->key ?>" onclick="doChangeLangType('<?php echo $__Context->key ?>'); return false;"><?php echo $__Context->val ?></a></li><?php } ?>
					</ul>
				</li>
			</ul>
		</div>
	</header>
	<!-- BODY -->
	<div class="body <?php if($__Context->_COOKIE['__xe_admin_gnb_status'] == 'close'){ ?>wide<?php } ?>">
		<!-- GNB -->
		<nav class="gnb <?php if($__Context->_COOKIE['__xe_admin_gnb_status'] == 'open'){ ?>open<?php } ?>" id="gnb">
			<a href="#gnbNav"><i class="x_icon-align-justify x_icon-white"></i><b></b> Menu Open/Close</a>
			<ul id="gnbNav"<?php if($__Context->_COOKIE['__xe_admin_gnb_ex_status'] == 'open'){ ?> class="ex"<?php } ?>>
			<script>
				var __xe_admin_gnb_txs = new Array();
			</script>
			<?php if($__Context->gnbUrlList&&count($__Context->gnbUrlList))foreach($__Context->gnbUrlList AS $__Context->key=>$__Context->value){ ?>
				<?php if(strstr($__Context->value['menu_name_key'], 'configuration')){ ?>
				<li<?php if($__Context->_COOKIE['__xe_admin_gnb_tx_favorite'] == 'open'){ ?> class="open"<?php } ?>>
					<script>
						__xe_admin_gnb_txs.push('__xe_admin_gnb_tx_favorite');
					</script>
					<a href="#favorite" data-href="favorite" title="<?php echo $__Context->lang->favorite ?>"><span class="tx"><?php echo $__Context->lang->favorite ?></span></a>
					<ul id="favorite"<?php if($__Context->_COOKIE['__xe_admin_gnb_tx_favorite'] == 'open'){ ?> style="display:block"<?php } ?>>
						<?php if($__Context->favorite_list&&count($__Context->favorite_list))foreach($__Context->favorite_list as $__Context->favorite){ ?><li>
							<a href="<?php echo getUrl('', 'module', 'admin', 'act', $__Context->favorite->admin_index_act) ?>" title="<?php echo $__Context->favorite->title ?>"><?php echo $__Context->favorite->title ?></a>
							<form class="remove" action="./" method="post"><input type="hidden" name="error_return_url" value="<?php echo htmlspecialchars(getRequestUriByServerEnviroment(), ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?>" /><input type="hidden" name="mid" value="<?php echo $__Context->mid ?>" /><input type="hidden" name="vid" value="<?php echo $__Context->vid ?>" />
								<input type="hidden" name="module" value="admin" />
								<input type="hidden" name="act" value="procAdminToggleFavorite" />
								<input type="hidden" name="site_srl" value="0" />
								<input type="hidden" name="module_name" value="<?php echo $__Context->favorite->module ?>" />
								<input type="hidden" name="success_return_url" value="<?php echo getUrl('', 'module', 'admin') ?>" />
								<button type="submit" class="x_close" title="<?php echo $__Context->lang->cmd_delete ?>">&times;</button>
							</form>
						</li><?php } ?>
						<?php if(!is_array($__Context->favorite_list) || count($__Context->favorite_list) < 1){ ?><li><a href="<?php echo getUrl('', 'module', 'admin', 'act', 'dispModuleAdminContent') ?>"><?php echo $__Context->lang->no_data ?></a></li><?php } ?>
					</ul>
					<div class="exMenu">
						<button type="button" title="<?php echo $__Context->lang->advanced_settings ?>"><i class="x_icon-chevron-down"></i><i class="x_icon-chevron-up"></i></button>
					</div>
				</li>
				<?php } ?>
				<li class="<?php if($__Context->parentSrl==$__Context->key || $__Context->value['href']=='index.php?module=admin' && !$__Context->mid && !$__Context->act){ ?>active open<?php }elseif($__Context->_COOKIE['__xe_admin_gnb_tx_' . md5($__Context->value['href'])] == 'open'){ ?>open<?php } ?>">
					<script>
						__xe_admin_gnb_txs.push('<?php echo '__xe_admin_gnb_tx_' . md5($__Context->value['href']) ?>');
					</script>
					<a href="<?php echo getFullUrl('');
echo $__Context->value['href'] ?>" data-href="<?php echo md5($__Context->value['href']) ?>" title="<?php echo $__Context->value['text'] ?>"><span class="tx"><?php echo $__Context->value['text'] ?></span></a>
					<?php if(count($__Context->value['list'])){ ?><ul<?php if($__Context->_COOKIE['__xe_admin_gnb_tx_' . md5($__Context->value['href'])] == 'open'){ ?> style="display:block"<?php } ?>>
						<?php if($__Context->value['list']&&count($__Context->value['list']))foreach($__Context->value['list'] as $__Context->key2=>$__Context->value2){;
if($__Context->value2['text']!=''){ ?><li<?php if($__Context->value2['text'] == $__Context->subMenuTitle){ ?> class="active_"<?php } ?> ><a href="<?php echo getFullUrl('');
echo $__Context->value2['href'] ?>" title="<?php echo $__Context->value2['text'] ?>"><?php echo $__Context->value2['text'] ?></a></li><?php }} ?>
					</ul><?php } ?>
				</li>
			<?php } ?>
			</ul>
		</nav>
		<!-- /GNB -->
