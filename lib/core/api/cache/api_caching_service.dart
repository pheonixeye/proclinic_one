// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:proklinik_one/core/api/_api_result.dart';

typedef ApiClassName = String;
typedef ParametrizedQueryName = String;

class _CacheDataStore {
  //TODO: check feasability of this implementation on long term
  const _CacheDataStore();

  static final Map<ApiClassName, Cachable> _dataCache = {};
}

// ignore: must_be_immutable
class Cachable<T> extends Equatable {
  final ParametrizedQueryName parametrizedQueryName;
  ApiDataResult<T>? _data;

  Cachable({
    required this.parametrizedQueryName,
    required ApiDataResult<T>? data,
  }) : _data = data;

  Cachable<T> copyWith({
    ParametrizedQueryName? parametrizedQueryName,
    ApiDataResult<T>? data,
  }) {
    return Cachable<T>(
      parametrizedQueryName:
          parametrizedQueryName ?? this.parametrizedQueryName,
      data: data ?? _data,
    );
  }

  @override
  List<Object?> get props => [
        parametrizedQueryName,
        _data,
      ];

  ApiDataResult<T>? operator [](ParametrizedQueryName query) {
    if (query == parametrizedQueryName) {
      return _data;
    } else {
      return null;
    }
  }

  void operator []=(ParametrizedQueryName query, ApiDataResult<T>? data) {
    if (query == parametrizedQueryName) {
      _data = data;
    }
  }
}

class ApiCachingService<T> {
  ApiCachingService();

  static final _cache = _CacheDataStore._dataCache;

  static Map<ApiClassName, Cachable> get cache => _cache;

  void addToCache(ApiClassName key, Cachable<T> cachable) {
    _cache[key] = cachable;
  }

  void invalidateCache(ApiClassName key, ParametrizedQueryName query) {
    _cache[key]?[query] = null;
  }

  bool operationIsCached(
    ApiClassName key,
    ParametrizedQueryName query,
  ) {
    final _classIsCached = _cache[key] != null;
    final _operationIsCached = _classIsCached && _cache[key]![query] != null;

    if (_classIsCached && _operationIsCached) {
      return true;
    }
    return false;
  }

  ApiDataResult<T>? getDataByKeys(
    ApiClassName key,
    ParametrizedQueryName query,
  ) {
    final _classIsCached = _cache[key] != null;
    final _operationIsCached = _classIsCached && _cache[key]![query] != null;

    if (_classIsCached && _operationIsCached) {
      return _cache[key]![query]! as ApiDataResult<T>;
    }
    return null;
  }
}
