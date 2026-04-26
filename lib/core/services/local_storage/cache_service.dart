 
import 'package:mizansir/core/services/local_storage/app_store.dart' show AppStore;
import 'package:mizansir/core/services/local_storage/app_store_imp.dart' show AppStoreImp;

class CacheService {
  CacheService._internal();

  static final AppStore _appStore = AppStoreImp();

  static AppStoreImp get instance => _appStore as AppStoreImp;
}
