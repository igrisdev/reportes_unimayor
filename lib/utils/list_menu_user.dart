import 'package:flutter/material.dart';

class _MenuGridItem {
  final String title;
  final IconData icon;
  final String route;

  const _MenuGridItem({
    required this.title,
    required this.icon,
    required this.route,
  });
}

final listMenuItemsUser = [
  const _MenuGridItem(
    title: 'Historial Reportes',
    icon: Icons.history,
    route: '/user/history',
  ),
  const _MenuGridItem(
    title: 'Datos Personales',
    icon: Icons.person,
    route: '/user/settings/general_information',
  ),
  const _MenuGridItem(
    title: 'Información Medica',
    icon: Icons.medical_information,
    route: '/user/settings/medical_information',
  ),
  const _MenuGridItem(
    title: 'Contactos de emergencia',
    icon: Icons.phone,
    route: '/user/settings/emergency_contacts',
  ),
];
