# SUSE's openQA tests
#
# Copyright © 2009-2013 Bernhard M. Wiedemann
# Copyright © 2012-2018 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: Very basic firefox test opening an html-test
# Maintainer: Stephan Kulow <coolo@suse.com>

package firefox;
use base "x11test";
use strict;
use testapi;

sub start_firefox {
    my ($self) = @_;
    # Using match_typed parameter on KDE as typing in desktop runner may fail
    x11_start_program('firefox https://html5test.opensuse.org', valid => 0, match_typed => ((check_var('DESKTOP', 'kde')) ? "firefox_url_typed" : ''));
    $self->firefox_check_default;
    $self->firefox_check_popups;
    assert_screen 'firefox-html-test';
}

sub run() {
    my ($self) = shift;
    mouse_hide(1);
    $self->start_firefox();
    send_key "alt-h";
    assert_screen 'firefox-help-menu';
    send_key "a";
    assert_screen 'test-firefox-3';

    # close About
    send_key "alt-f4";
    assert_screen 'firefox-html-test';

    send_key "alt-f4";
    assert_screen [qw(firefox-save-and-quit generic-desktop)];
    if (match_has_tag 'firefox-save-and-quit') {
        # confirm "save&quit"
        send_key "ret";
    }
}

1;
