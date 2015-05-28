<?php
$lang->member='Member';
$lang->site='Site';
$lang->member_default_info='Basic Info';
$lang->member_extend_info='Additional Info';
$lang->default_group_1='Associate Member';
$lang->default_group_2='Regular Member';
$lang->default_group='Default Group';
$lang->admin_group='Managing Group';
$lang->keep_signed='Keep me signed in.';
$lang->remember_user_id='Remember ID.';
$lang->already_logged='You are already signed in.';
$lang->denied_user_id='You have entered a prohibited ID.';
$lang->denied_nick_name='You have entered a prohibited nick name.';
$lang->null_user_id='Please enter your ID.';
$lang->null_password='Please enter your password.';
$lang->invalid_authorization='The account is not activated.';
$lang->invalid_email_address='You have entered an invalid email address. There is no member who has the email, entered.';
$lang->invalid_user_id='You have entered an invalid ID.';
$lang->invalid_password='You have entered an invalid password.';
$lang->invalid_new_password='Please enter a password you haven\'t previously used.';
$lang->allow_mailing='Join Mailing';
$lang->is_admin='Superadmin Permission';
$lang->member_group='Member Group';
$lang->group_title='Group Name';
$lang->group_srl='Group Number';
$lang->group_order='Gropu Priority';
$lang->group_order_change='Change Group Priority';
$lang->signature='Signature';
$lang->profile_image='Profile Image';
$lang->profile_image_max_width='Max Width';
$lang->profile_image_max_height='Max Height';
$lang->image_name='Image Name';
$lang->image_name_max_width='Max Width';
$lang->image_name_max_height='Max Height';
$lang->image_mark='Image Mark';
$lang->image_mark_max_width='Max Width';
$lang->image_mark_max_height='Max Height';
$lang->group_image_mark='Group Image Mark';
$lang->group_image_mark_max_width='Max Width';
$lang->group_image_mark_max_height='Max Height';
$lang->signature_max_height='Max Signature Height';
$lang->enable_join='Accept New Members';
$lang->enable_confirm='Email Activation';
$lang->enable_ssl='Enable SSL';
$lang->security_sign_in='Sign in using enhanced security';
$lang->limit_day='Temporary Limit Date';
$lang->limit_date='Limit Date';
$lang->after_login_url='URL to redirect after Sign in';
$lang->after_logout_url='URL to redirect after Sign out';
$lang->redirect_url='URL to redirect after Sign up';
$lang->agreement='Terms of Service';
$lang->accept_agreement='Agree';
$lang->member_info='User Info';
$lang->current_password='Current Password';
$lang->allow_message='Allow Messages';
if(!is_array($lang->allow_message_type)){
	$lang->allow_message_type = array();
}
$lang->allow_message_type['Y']='Allow All';
$lang->allow_message_type['F']='Allow for Friends only';
$lang->allow_message_type['N']='Reject All';
$lang->about_allow_message='You may allow or reject messages.';
$lang->logged_users='Logged on Users';
$lang->msg_mail_authorization='메일 인증을 사용하려면 웸마스터의 이름과 메일주소가 유효해야 합니다.';
$lang->webmaster_name='Webmaster Name';
$lang->webmaster_email='Webmaster Email';
$lang->column_id='The column id';
$lang->about_column_id='입력항목의 구분자로 사용될 ID입니다. 영문으로 시작하고 영문 숫자만 사용가능합니다.';
$lang->options='Options';
$lang->about_keep_signed='You will be still signed in even when the browser is closed.\n\nIt is not recommended to use this if you are using a public computer, for your personal information could be violated.';
$lang->about_keep_warning='You will be still signed in even when the browser is closed. It is not recommended to use this if you are using a public computer, for your personal information could be violated';
$lang->about_webmaster_name='Please enter webmaster\'s name which will be used for verification mails or other site administration. (default : webmaster).';
$lang->about_webmaster_email='Please enter webmaster\'s email address.';
if(!is_array($lang->search_target_list)){
	$lang->search_target_list = array();
}
$lang->search_target_list['email_address']='Email Address';
$lang->search_target_list['regdate']='Sign up Date';
$lang->search_target_list['regdate_more']='Sign up Date (more)';
$lang->search_target_list['regdate_less']='Sign up Date (less)';
$lang->search_target_list['last_login']='Last Sign in Date';
$lang->search_target_list['last_login_more']='Last Sign in Date (more)';
$lang->search_target_list['last_login_less']='Last Sign in Date (less)';
$lang->search_target_list['extra_vars']='User Defined';
$lang->cmd_modify_new_auth_email_address='New email address';
$lang->cmd_set_design_info='Desgin';
$lang->cmd_login='Sign In';
$lang->cmd_logout='Sign Out';
$lang->cmd_signup='Sign Up';
$lang->cmd_site_signup='Sign Up';
$lang->cmd_modify_member_email_address='Change Email Address';
$lang->about_modify_member_email_address='You could change Email Address.';
$lang->cmd_modify_member_info='Change Member Info';
$lang->cmd_modify_member_password='Change Password';
$lang->cmd_view_member_info='View Member Info';
$lang->cmd_leave='Delete Account';
$lang->cmd_find_member_account='Find Account Info';
$lang->cmd_find_member_account_with_email='Find Account with Email address';
$lang->cmd_find_member_account_with_email_question='Find Account with Q&amp;A';
$lang->cmd_resend_auth_mail='Request for Activation Mail';
$lang->cmd_send_auth_new_emaill_address='Request for activation mail to new email';
$lang->cmd_member_list='Member List';
$lang->cmd_module_config='Default Setting';
$lang->cmd_member_group='Member Groups';
$lang->cmd_send_mail='Send Mail';
$lang->cmd_manage_id='Prohibited IDs';
$lang->cmd_manage_nick_name='Prohibited NickNames';
$lang->cmd_manage_form='Signup Form';
$lang->cmd_view_own_document='Written Articles';
$lang->cmd_manage_member_info='Manage Member Info';
$lang->cmd_trace_document='Trace Written Articles';
$lang->cmd_trace_comment='Trace Written Comments';
$lang->cmd_view_scrapped_document='Scraps';
$lang->cmd_view_saved_document='Saved Articles';
$lang->cmd_send_email='Send Mail';
$lang->msg_email_not_exists='You have entered an invalid email address.';
$lang->msg_alreay_scrapped='This article is already scrapped.';
$lang->msg_cart_is_null='Please select the target.';
$lang->msg_checked_file_is_deleted='%d attached file(s) is(are) deleted.';
$lang->msg_find_account_title='Account Info';
$lang->msg_find_account_info='This is requested account info.';
$lang->msg_find_account_comment='The password will be modified as the one above as you click the link below.<br />Please modify the password after login.';
$lang->msg_confirm_account_title='XE Account Activation';
$lang->title_modify_email_address='이메일주소 변경 요청 확인 메일입니다.';
$lang->msg_confirm_account_info='This is your account information:';
$lang->msg_confirm_account_comment='Click on the following link to complete your account activation.';
$lang->msg_confirm_email_address_change='아래 링크를 클릭하면 이메일 주소가 %s으로 변경됩니다.';
$lang->msg_auth_mail_sent='The activation mail has been sent to %s. Please check your mail.';
$lang->msg_confirm_mail_sent='We have just sent the activation email to %s. Please check your mail.';
$lang->msg_invalid_modify_email_auth_key='잘못된 이메일 변경 요청입니다.<br />이메일 변경요청을 다시 하거나 사이트 관리자에게 문의해주세요.';
$lang->msg_invalid_auth_key='This is an invalid request of verification.<br />Please retry finding account info or contact the administrator.';
$lang->msg_success_authed='Your account has been successfully activated and logged on.\n Please modify the password to your own one with the password in the mail.';
$lang->msg_success_confirmed='Your account has been activated successfully.';
$lang->msg_new_member='Add Member';
$lang->msg_rechecked_password='Re-checked password';
$lang->msg_update_member='Inquiry/Modify User Info';
$lang->msg_leave_member='Delete Account';
$lang->msg_group_is_null='There is no group.';
$lang->msg_not_delete_default='Default items cannot be deleted';
$lang->msg_not_exists_member='Invalid member';
$lang->msg_cannot_delete_admin='Admin ID cannot be deleted. Please remove the ID from administration and try again.';
$lang->msg_exists_user_id='This ID already exists. Please try another one.';
$lang->msg_exists_email_address='This email address already exists. Please try another one.';
$lang->msg_exists_nick_name='This nickname already exists. Please try another one.';
$lang->msg_signup_disabled='You are not able to sign up';
$lang->msg_already_logged='You have already signed up.';
$lang->msg_not_logged='Please sign in first.';
$lang->msg_insert_group_name='Please enter the name of group.';
$lang->msg_check_group='Please select the group.';
$lang->msg_not_uploaded_profile_image='Profile image could not be registered.';
$lang->msg_not_uploaded_image_name='Image name could not be registered.';
$lang->msg_not_uploaded_image_mark='Image mark could not be registered.';
$lang->msg_not_uploaded_group_image_mark='Group image mark could not be registered.';
$lang->msg_accept_agreement='You have to accept the agreement.';
$lang->msg_user_denied='You have entered a prohibited ID.';
$lang->msg_user_not_confirmed='Your account is not activated yet. Please check your email.';
$lang->msg_user_limited='You have entered an ID that cannot be used before %s';
$lang->about_rechecked_password='Confirm your password before editing account information.';
$lang->about_user_id='User ID should be 3~20 characters long, consist of alphanumeric and start with a letter.';
$lang->about_password='Password should be 6~20 characters long.';
$lang->cmd_config_password_strength='password strength';
$lang->password_strength_low='low';
$lang->password_strength_normal='normal';
$lang->password_strength_high='high';
$lang->about_password_strength_config='When members register or change the password, the password must meet the specified password strength. However, the administrator is an exception.';
if(!is_array($lang->about_password_strength)){
	$lang->about_password_strength = array();
}
$lang->about_password_strength['low']='the password must be at least 4';
$lang->about_password_strength['normal']='the password must be at least 6, and must have at least one alpha character and numeric characters';
$lang->about_password_strength['high']='the password must be at least 8, and must have at least one alpha character, numeric character and special character ';
$lang->about_user_name='Name should be 2~20 letters long.';
$lang->about_nick_name='Nickname should be 2~20 characters long.';
$lang->about_email_address='Email address will be used to modify/find password after email verification.';
$lang->about_homepage='Please enter your homepage address if you have any.';
$lang->about_blog_url='Please enter your blog address if you have any.';
$lang->about_birthday='Please enter your birth date.';
$lang->about_allow_mailing='If you don\'t join mailing, you will not able to receive group mails';
$lang->about_denied='Check this to prohibit the ID.';
$lang->about_is_admin='Check this to give Superadmin permissions.';
$lang->about_member_description='Administrator\'s memo about user.';
$lang->about_group='An ID can belong to many groups.';
$lang->about_column_type='Please set the format of additional signup form.';
$lang->about_column_name='Please enter English name that can be used in the template (name as variable).';
$lang->about_column_title='This will be displayed on signup or modifying/viewing member info form.';
$lang->about_default_value='You can set the values to enter by default.';
$lang->about_active='You have to check on active items to show on signup form.';
$lang->about_form_description='If you enter description in this form, it will be displayed on join form.';
$lang->about_required='Check this to make it mandatory item when signing up.';
$lang->about_enable_join='Please check this if you want to allow new members to sign up your site.';
$lang->about_enable_confirm='Please check if you want new members to activate their accounts via their emails.';
$lang->about_enable_ssl='Personal information from Sign up/Modify Member Info/Sign in can be sent as SSL(https) mode if server provides SSL service.';
$lang->about_limit_day='You can limit activation date after sign up';
$lang->about_limit_date='Users cannot sign in until the specified date';
$lang->about_after_login_url='You can set a URL after login. Blank means the current page.';
$lang->about_after_logout_url='You can set a URL after logout. Blank means the current page.';
$lang->about_redirect_url='Please select a page where users will go after sign up. When this is empty, it will be set as the previous page of the sign up page.';
$lang->about_agreement='Sign up Agreement will be displayed if it\'s not empty';
$lang->about_image_name='Members will be able to use image name instead of text';
$lang->about_image_mark='Members will be able to use image mark in front of their names';
$lang->about_group_image_mark='You may use group marks shown before their names';
$lang->about_profile_image='Members will be able to use profile images';
$lang->about_signature_max_height='You can limit the signature max height. Set this as 0 or leave it blank not to limit it.';
$lang->about_accept_agreement='I have read the agreement and agree with it';
$lang->about_member_default='It will be set as the default group on sign up';
$lang->about_find_member_account='lease input the email address you have entered during the registration and we will send your account info to this email address.';
$lang->about_temp_password='임시 비밀번호가 정상적으로 발급되었습니다.<br />로그인 후 반드시 비밀번호를 변경하세요.<br />';
$lang->about_ssl_port='Please enter if you are using non-default SSL port';
$lang->about_reset_auth_mail='현재등록된 이메일 주소는 %s입니다. 이메일 주소를 변경하고자 하는 경우 새로운 이메일 주소로 회원정보 갱신 후 인증메일을 재발송할 수 있습니다.';
$lang->about_resend_auth_mail='You can request for the activation email if you have not activated yet.';
$lang->about_reset_auth_mail_submit='이메일을 로그인 계정으로 사용할 경우 신규 메일주소로 로그인해야 합니다.';
$lang->no_article='No articles';
$lang->find_account_question='Question for a temporary password.';
$lang->find_account_answer='Answer for a temporary password.';
$lang->about_find_account_question='You can get a temporary password by your ID, email address, and the answer for the question you have set.';
if(!is_array($lang->find_account_question_items)){
	$lang->find_account_question_items = array();
}
$lang->find_account_question_items['1']='What is your alternate email address?';
$lang->find_account_question_items['2']='What is your favorite thing?';
$lang->find_account_question_items['3']='Which elementary school did you attend?';
$lang->find_account_question_items['4']='Where is your hometown?';
$lang->find_account_question_items['5']='What is your ideal match?';
$lang->find_account_question_items['6']='What is your mother\'s name?';
$lang->find_account_question_items['7']='What is your father\'s name?';
$lang->find_account_question_items['8']='What is your favorite color?';
$lang->find_account_question_items['9']='What is your favorite food?';
$lang->temp_password='Temporary password';
$lang->cmd_get_temp_password='Get a temporary password';
$lang->about_get_temp_password='Change your password after you logged in.';
$lang->msg_question_not_exists='You haven`t set your question for a temporary password.';
$lang->msg_answer_not_matches='Your answer for the question is not correct.';
$lang->change_password_date='Password renewal cycle';
$lang->about_change_password_date='If you set a value to this, you will be notified to change your password periodically. (If set to 0, disabled)';
$lang->login_trial_limit1='Sign in trial limit';
$lang->login_trial_limit2='Sign in trial limit';
$lang->about_login_trial_limit1='Set the number of trial limit. Limit the number of trial to sign in from a IP address.';
$lang->about_login_trial_limit2='Set the time limit to try the written times of sign in. Limit the number of trial to sign in during the span of time, from a IP address.';
$lang->msg_kr_address='Search for the name of eup, myeon or dong of your address.';
$lang->msg_kr_address_etc='Enter the rest of your address.';
$lang->cmd_search_again='Search again';
$lang->msg_select_user='Please select a member to manage.';
$lang->msg_delete_user='Delete the selected member.';
$lang->cmd_selected_user_manage='Manage selected memter';
$lang->about_change_user_group='Resets the selected group of memebers.';
$lang->about_send_message='Send a message to the member about this. If you don\'t write a message, it is not sent.';
$lang->cmd_required='Required';
$lang->cmd_optional='Optional';
$lang->cmd_image_max_width='Max Width';
$lang->cmd_image_max_height='Max Height';
$lang->cmd_input_extend_form='User Defined Input';
$lang->about_multi_type='Enter the value of multi-or single-item selection.(separated by line breaks)';
$lang->msg_delete_extend_form='Delete the selected item.';
$lang->set_manage_id='Separated by line breaks.';
$lang->count_manage_id='There are <span class="_deniedIDCount">%s</span> prohibited ID.';
$lang->count_manage_nick_name='There are <span class="_deniedNickNameCount">%s</span> prohibited nick name.';
$lang->user_list='Member List';
$lang->cmd_show_all_member='All Member';
$lang->cmd_show_super_admin_member='Super Admin';
$lang->cmd_show_site_admin_member='Site Admin';
$lang->approval='Approval';
$lang->denied='Denied';
$lang->use_group_image_mark='Use group image mark';
$lang->group_image_mark='Group image mark';
$lang->usable_group_image_mark_list=' Usable list of group image mark';
$lang->add_group_image_mark='Add group image mark';
$lang->link_file_box='Go to Manage FileBox';
$lang->msg_group_delete='Delete selected group.';
$lang->email='Email';
$lang->add_prohibited_id='Add prohibited id';
$lang->multi_line_input='To enter multiple entries, please change the line input.';
$lang->add_extend_form='Add user defined item';
$lang->msg_null_prohibited_id='Please enter an ID to prohibit.';
$lang->msg_null_prohibited_nick_name='Please enter a nick name to prohibit.';
$lang->identifier='Login Account';
$lang->about_identifier='Please select an account to use when logging in.';
$lang->about_public_item='본인 외에 다른 회원에게도 노출될 정보인지 선택합니다.';
$lang->use_after_save='Use after saved';
$lang->cmd_add_group='Add group';
$lang->msg_groups_exist='groups exist.';
$lang->cmd_member_config='Member Configuration';
$lang->cmd_member_sync='회원정보 동기화';
$lang->about_member_sync='회원정보와 게시물/댓글 정보를 동기화 합니다. 데이터가 많은 경우 시간이 오래 소요될 수 있습니다. <strong>이용자가 많은 경우 반드시 서비스를 중단하고 진행하세요.</strong>';
$lang->msg_success_modify_email_address='이메일 주소가 정상적으로 변경되었습니다. 변경된 이메일 주소로 로그인 가능합니다.';
$lang->group='Group';
$lang->retrieve_password='Retrieve password';
$lang->excess_ip_access_count='There was too much sign in trial from your devices in a short time. You can not sign in for %s.';
$lang->enable_login_fail_report='Sign in failure';
$lang->login_fail_report='Sign in failure report.';
$lang->login_fail_report_contents='<h2>There is recorded sign in failures.</h2>%1$s<hr /><p>* This notification is shown once.<br />* This message contains sign in failure records, before a ID sign in success.<br />Sending: %2$s</p>';
$lang->all_group='Entire Group';
$lang->msg_insert_group_name_detail='If group title are empty, does not apply.';
$lang->msg_exist_selected_module='Address information does not exist.';
$lang->cmd_spammer='Spam User Manage';
$lang->spammer_description='<p>Spam user management. This function denied user login and remove all of documents, comments</p>';
$lang->btn_spammer_delete_all='Delete all';
$lang->spammer_move_to_trash='Move to trash';