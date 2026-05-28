import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:seimbangin_app/services/local_database_service.dart';
import 'package:seimbangin_app/shared/theme/theme.dart';

class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({super.key});

  @override
  State<CategoryManagementPage> createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage>
    with SingleTickerProviderStateMixin {
  final LocalDatabaseService _dbService = LocalDatabaseService();
  late TabController _tabController;

  List<Map<String, dynamic>> _incomeCategories = [];
  List<Map<String, dynamic>> _outcomeCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    final income = await _dbService.getCategories('income');
    final outcome = await _dbService.getCategories('outcome');

    if (mounted) {
      setState(() {
        _incomeCategories = income;
        _outcomeCategories = outcome;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteCategory(int id) async {
    await _dbService.deleteCategory(id);
    _loadCategories();
  }

  void _showAddCategoryModal() {
    final type = _tabController.index == 0 ? 'income' : 'outcome';
    final nameController = TextEditingController();
    int selectedIconCode = Icons.category_rounded.codePoint;

    final icons = [
      Icons.category_rounded,
      Icons.fastfood_rounded,
      Icons.shopping_bag_rounded,
      Icons.directions_car_rounded,
      Icons.train_rounded,
      Icons.flight_rounded,
      Icons.local_hospital_rounded,
      Icons.home_rounded,
      Icons.work_rounded,
      Icons.school_rounded,
      Icons.attach_money_rounded,
      Icons.sports_esports_rounded,
      Icons.music_note_rounded,
      Icons.pets_rounded,
      Icons.card_giftcard_rounded,
      Icons.receipt_long_rounded,
      Icons.wifi_rounded,
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(builder: (context, setModalState) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24.w,
            right: 24.w,
            top: 24.h,
          ),
          decoration: BoxDecoration(
            color: context.color.backgroundWhiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tambah Kategori ${type == 'income' ? 'Pemasukan' : 'Pengeluaran'}',
                    style: context.text.blackTextStyle.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close,
                        color: context.color.textSecondaryColor),
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Kategori',
                  hintText: 'Misal: Asuransi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Pilih Ikon',
                style: context.text.blackTextStyle.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              SizedBox(
                height: 200.h,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                  ),
                  itemCount: icons.length,
                  itemBuilder: (context, index) {
                    final icon = icons[index];
                    final isSelected = selectedIconCode == icon.codePoint;
                    return GestureDetector(
                      onTap: () {
                        setModalState(() {
                          selectedIconCode = icon.codePoint;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? context.color.primaryColor
                              : context.color.backgroundGreyColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: isSelected
                              ? Colors.white
                              : context.color.textSecondaryColor,
                          size: 24.r,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.color.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  onPressed: () async {
                    if (nameController.text.trim().isEmpty) return;
                    // Capture the pop action before the async gap
                    final popModal = context.pop;

                    await _dbService.insertCategory({
                      'name': nameController.text.trim(),
                      'type': type,
                      'icon_code': selectedIconCode,
                    });

                    popModal();
                    _loadCategories();
                  },
                  child: Text(
                    'Simpan',
                    style: context.text.whiteTextStyle.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCategoryList(List<Map<String, dynamic>> categories) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (categories.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada kategori custom',
          style: context.text.greyTextStyle,
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(24.r),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final iconData =
            IconData(cat['icon_code'] as int, fontFamily: 'MaterialIcons');

        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: context.color.backgroundWhiteColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: context.color.backgroundGreyColor),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: context.color.backgroundGreyColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(iconData,
                    color: context.color.primaryColor, size: 24.r),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  cat['name'] as String,
                  style: context.text.blackTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline_rounded,
                    color: context.color.backgroundWarningColor),
                onPressed: () => _deleteCategory(cat['id'] as int),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.backgroundWhiteColor,
      appBar: AppBar(
        backgroundColor: context.color.backgroundWhiteColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: context.color.textPrimaryColor),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Kategori Transaksi',
          style: context.text.blackTextStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: context.color.primaryColor,
          labelColor: context.color.primaryColor,
          unselectedLabelColor: context.color.textSecondaryColor,
          labelStyle:
              context.text.blackTextStyle.copyWith(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Pemasukan'),
            Tab(text: 'Pengeluaran'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCategoryList(_incomeCategories),
          _buildCategoryList(_outcomeCategories),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCategoryModal,
        backgroundColor: context.color.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
