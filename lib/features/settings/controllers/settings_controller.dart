import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  var mobileDataUsage = 'Somente Wi-Fi'.obs;
  final box = GetStorage();

  var cacheSizeMb = 0.0.obs;

  @override
  void onInit() {
    super.onInit();

    final savedUsage = box.read<String>('mobileDataUsage');
    if (savedUsage != null) {
      mobileDataUsage.value = savedUsage;
    }

    loadCacheSize();
  }

  // Função pra verificar qual tipo de rede o usuario prefere usar
  Future<bool> canUseInternet() async {
    final usage = mobileDataUsage.value;

    final results = await Connectivity().checkConnectivity();

    // Sem internet
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return false;
    }

    // Usar qualquer tipo de rede
    if (usage == 'Sempre') {
      return true;
    }

    // Se está conectado ao wifi
    if (usage == 'Somente Wi-Fi') {
      return results.contains(ConnectivityResult.wifi);
    }

    return false;
  }

  // Atualiza a preferencia de rede do usuario
  void setMobileDataUsage(String value) {
    mobileDataUsage.value = value;
    box.write('mobileDataUsage', value);
  }

  // Carrega o cache total
  Future<void> loadCacheSize() async {
    final cacheDir = await getTemporaryDirectory();
    int totalSize = 0;

    if (cacheDir.existsSync()) {
      for (var entity in cacheDir.listSync(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
    }
    cacheSizeMb.value = totalSize / (1024 * 1024);
  }

  // Função de limpar o cache
  Future<void> clearAppCache() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      for (var entity in cacheDir.listSync()) {
        try {
          if (entity is File) {
            await entity.delete();
          } else if (entity is Directory) {
            await entity.delete(recursive: true);
          }
        } catch (_) {}
      }
    }

    await loadCacheSize();
  }

  // Pergunta pro usuario se quer limpar msm e chama a funcao de limpar
  Future<void> confirmClearCache(BuildContext context) async {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: CbSizes.lg),
      contentPadding: EdgeInsets.all(CbSizes.lg),
      title: 'Limpar cache',
      middleText: 'Isso remove apenas arquivos temporários e não apaga seus treinos ou progresso.',
      confirm: ElevatedButton(
        onPressed: () async {
          Get.back();
          await clearAppCache();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: CbColors.primary,
        ),  
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: CbSizes.lg),
          child: Text('Limpar'),
        )
      ),
      cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: Text('Cancelar'),
      ),
      backgroundColor: isDarkMode ? CbColors.dark : CbColors.white,
    );
  }

  // Funcao pra abrir o insta do Carboneto
  Future<void> openInstagram() async {
    final Uri url = Uri.parse('https://www.instagram.com/carboneto.app/');

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication, // abre fora do app
    )) {
      throw 'Não foi possível abrir o Instagram';
    }
  }
}
