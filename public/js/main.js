$(document).ready(function(){
	if ($("#encrypt_button").length > 0) {
		$("#encrypt_button").on ('click', function () {
			encrypt_new_secret();
		});
		$("#encrypt_password").on ('keyup', function (e) {
			if (e.which == 13) {
				encrypt_new_secret();
			}
		});
		$("#show_finish_link").fancybox ();
		$("#finish_info").on ('click', '.value', function () {
			select_text ($(this).get(0));
		});
	}

	if ($("#decrypt_button").length > 0)
	{
		$("#decrypt_button").on ('click', function () {
			decrypt_secret ();
		});
		$("#decrypt_password").on ('keyup', function (e) {
			if (e.which == 13) {
				decrypt_secret ();
			}
		});
	}
});

function encrypt_new_secret () {
	var secret = $("#raw_secret").val ();
	var key = $("#encrypt_password").val ();
	if (!secret || !key)
	{
		alert ('Hey, we need a secret and a password before we can get started!');
		return;
	}

	var encrypted = GibberishAES.enc (secret, key);

	$.ajax ({
		type: 'POST',
		url: '/secrets',
		data: { encrypted_secret: encrypted },
		dataType: 'json'
	}).done (function (response, status) {
		if (status == 'success' && response && response.url)
		{
			$("#show_secret_url").text (response.url);
			$("#show_secret_key").text (key);
			$("#show_finish_link").trigger ('click');
		}
		else
		{
			alert ('Oops, something went wrong. Please try again.');
		}
	}).error (function () {
		alert ('Oops, something went wrong. Please try again.');
	});
}

function decrypt_secret (encrypted, key, $target) {
	var key = $("#decrypt_password").val ();
	var encrypted = $("#encrypted_secret").val ();
	var $target = $("#decrypted_secret");
	try {
		var decrypted = GibberishAES.dec (encrypted, key);
		$target.text (decrypted);
	} catch (err) {
		alert ("Oops, that's not the right password.");
	}
}

function select_text(element) {
    var doc = document; 
    if (doc.body.createTextRange) { // ms
        var range = doc.body.createTextRange();
        range.moveToElementText(element);
        range.select();
    } else if (window.getSelection) {
        var selection = window.getSelection();
        if (selection.setBaseAndExtent) { // webkit
            selection.setBaseAndExtent(element, 0, element, 1);
        } else { // moz, opera
            var range = doc.createRange();
            range.selectNodeContents(element);
            selection.removeAllRanges();
            selection.addRange(range);
        }
    }
}
