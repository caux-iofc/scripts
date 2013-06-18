You can configure a Mac for IofC use like so:

    $ sudo ./mac-install-internal
    Login: iofc

If there are other printers installed, you'll be asked if you want to delete them. The answer is almost definitely yes.

That should be all you need to do, other than installing the printers. To do that (this is safe to run on a user's machine, too):

    $ sudo ./install-third-floor-printers
    Installing printer: lower
    Installing printer: upper
