enum Role {
  nothing,
  customer,
  admin,
}

class CustomerRole {
  final Role role;
  final String roleString;
  const CustomerRole({required this.role, required this.roleString});
}

const List<CustomerRole> customerRoles = [
  CustomerRole(role: Role.admin, roleString: "Admin"),
  CustomerRole(role: Role.customer, roleString: "Customer"),
];
