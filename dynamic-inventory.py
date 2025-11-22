#!/usr/bin/env python3
import libvirt
import json

def get_vm_inventory():
    """
    Returns Ansible dynamic inventory in JSON format.
    - Uses QEMU guest agent for IP discovery first
    - Falls back to libvirt DHCP leases
    - Ignores loopback IPs
    - Adds all VMs into a single group 'terraform-hosts'
    """
    conn = libvirt.open('qemu:///system')
    if conn is None:
        print("Failed to open connection to qemu:///system")
        return {}

    inventory = {
        "terraform-hosts": {"hosts": []},
        "_meta": {"hostvars": {}}
    }

    try:
        domain_ids = conn.listDomainsID()
    except:
        domain_ids = []

    for domain_id in domain_ids:
        domain = conn.lookupByID(domain_id)
        name = domain.name()
        ip_address = None

        # -------- Guest agent IP discovery --------
        try:
            ifaces = domain.interfaceAddresses(
                libvirt.VIR_DOMAIN_INTERFACE_ADDRESSES_SRC_AGENT,
                0
            )
            for iface in ifaces.values():
                for addr in iface.get("addrs", []):
                    if addr["type"] == libvirt.VIR_IP_ADDR_TYPE_IPV4 and addr["addr"] != "127.0.0.1":
                        ip_address = addr["addr"]
                        break
                if ip_address:
                    break
        except libvirt.libvirtError:
            pass

        # -------- Fallback: libvirt DHCP leases --------
        if not ip_address:
            try:
                net = conn.networkLookupByName("default")
                leases = net.DHCPLeases()
                for lease in leases:
                    if lease.get("hostname") == name:
                        ip_address = lease["ipaddr"]
                        break
            except:
                pass

        # -------- Skip VMs without real IP --------
        if not ip_address:
            continue

        # -------- Add host to terraform-hosts group --------
        inventory["terraform-hosts"]["hosts"].append(name)
        inventory["_meta"]["hostvars"][name] = {"ansible_host": ip_address}

    conn.close()
    return inventory


if __name__ == "__main__":
    inv = get_vm_inventory()
    print(json.dumps(inv, indent=2))
