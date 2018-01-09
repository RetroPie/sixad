# You know, there are pre-compile DEBs of this...

CXX ?= g++
CXXFLAGS += -O2 -Wall 
LDFLAGS += -Wl,-Bsymbolic-functions

ifeq ($(DEVICE_SHORT_NAME),1)
CXXFLAGS += -DSHORT_NAME
endif

all: sixad_bins sixpair_bin

sixad_bins:
	mkdir -p bins
	$(CXX) $(CXXFLAGS) $(LDFLAGS) sixad-bin.cpp bluetooth.cpp shared.cpp textfile.cpp -o bins/sixad-bin `pkg-config --cflags --libs bluez` -lpthread -fpermissive
	$(CXX) $(CXXFLAGS) $(LDFLAGS) sixad-sixaxis.cpp sixaxis.cpp shared.cpp uinput.cpp textfile.cpp -o bins/sixad-sixaxis -lpthread -lrt
	$(CXX) $(CXXFLAGS) $(LDFLAGS) sixad-remote.cpp remote.cpp shared.cpp uinput.cpp textfile.cpp -o bins/sixad-remote -lrt
	$(CXX) $(CXXFLAGS) $(LDFLAGS) sixad-raw.cpp sixaxis.cpp shared.cpp uinput.cpp textfile.cpp -o bins/sixad-raw
	$(CXX) $(CXXFLAGS) $(LDFLAGS) sixad-3in1.cpp sixaxis.cpp shared.cpp uinput.cpp textfile.cpp -o bins/sixad-3in1

sixpair_bin:
	mkdir -p bins
	$(CC) $(CFLAGS) $(LDFLAGS) sixpair.c -o bins/sixpair `pkg-config --cflags --libs libusb`

clean:
	rm -f *~ bins/*

install:
	install -d $(DESTDIR)/etc/default/
	install -d $(DESTDIR)/etc/systemd/system/
	install -d $(DESTDIR)/etc/logrotate.d/
	install -d $(DESTDIR)/usr/bin/
	install -d $(DESTDIR)/usr/sbin/
	install -d $(DESTDIR)/var/lib/sixad/
	install -d $(DESTDIR)/var/lib/sixad/profiles/
	install -m 644 sixad.default $(DESTDIR)/etc/default/sixad
	install -m 644 sixad.service $(DESTDIR)/etc/systemd/system/
	install -m 644 sixad.log $(DESTDIR)/etc/logrotate.d/sixad
	install -m 755 sixad $(DESTDIR)/usr/bin/
	install -m 755 bins/sixad-bin $(DESTDIR)/usr/sbin/
	install -m 755 bins/sixad-sixaxis $(DESTDIR)/usr/sbin/
	install -m 755 bins/sixad-remote $(DESTDIR)/usr/sbin/
	install -m 755 bins/sixad-3in1 $(DESTDIR)/usr/sbin/
	install -m 755 bins/sixad-raw $(DESTDIR)/usr/sbin/
	install -m 755 bins/sixpair $(DESTDIR)/usr/sbin/
	install -m 644 default $(DESTDIR)/var/lib/sixad/profiles/
	install -m 755 sixad-helper $(DESTDIR)/usr/sbin/
	install -m 644 99-sixad.rules $(DESTDIR)/etc/udev/rules.d
	install -m 644 10-hci.rules $(DESTDIR)/etc/udev/rules.d

	@chmod 777 -R $(DESTDIR)/var/lib/sixad/
	@echo "Installation is Complete!"

uninstall:
	rm -f $(DESTDIR)/etc/default/sixad
	rm -f $(DESTDIR)/etc/systemd/system/sixad.service
	rm -f $(DESTDIR)/etc/logrotate.d/sixad
	rm -f $(DESTDIR)/usr/bin/sixad
	rm -f $(DESTDIR)/usr/sbin/sixad-bin
	rm -f $(DESTDIR)/usr/sbin/sixad-sixaxis
	rm -f $(DESTDIR)/usr/sbin/sixad-remote
	rm -f $(DESTDIR)/usr/sbin/sixad-3in1
	rm -f $(DESTDIR)/usr/sbin/sixad-raw
	rm -f $(DESTDIR)/usr/sbin/sixpair
	rm -f $(DESTDIR)/usr/sbin/sixad-helper
	rm -f $(DESTDIR)/etc/udev/rules.d/99-sixad.rules
	rm -f $(DESTDIR)/etc/udev/rules.d/10-hci.rules
	rm -rf $(DESTDIR)/var/lib/sixad/
