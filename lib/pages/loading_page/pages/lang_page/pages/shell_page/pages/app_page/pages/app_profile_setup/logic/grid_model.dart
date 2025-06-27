// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:proklinik_one/assets/assets.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';

class GridModel extends Equatable {
  final String asset;
  final String title;
  final String path;

  const GridModel({
    required this.asset,
    required this.title,
    required this.path,
  });

  @override
  List<Object> get props => [asset, title];
}

List<GridModel> gridModelList(BuildContext context) => [
      GridModel(
        asset: AppAssets.drugs,
        title: context.loc.doctorDrugs,
        path: 'drugs',
      ),
      GridModel(
        asset: AppAssets.labs,
        title: context.loc.laboratoryRequests,
        path: 'labs',
      ),
      GridModel(
        asset: AppAssets.radiology,
        title: context.loc.radiology,
        path: 'rads',
      ),
      GridModel(
        asset: AppAssets.procedures,
        title: context.loc.procedures,
        path: 'procedures',
      ),
      GridModel(
        asset: AppAssets.supplies,
        title: context.loc.supplies,
        path: 'supplies',
      ),
    ];
