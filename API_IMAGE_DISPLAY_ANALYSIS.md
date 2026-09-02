# API Image Display Analysis - Flutter Quality App

## Summary
This document details where API images are being displayed in UI widgets across the application. All findings are from active (non-commented) code.

---

## 1. **Helper Widget Function** - `app_assets.dart`

**File:** `lib/View/Constant/app_assets.dart`

### networkImageShimmer Widget (Primary Image Display Method)
```dart
Widget networkImageShimmer(
    {required double h,
    required double w,
    required String url,
    double? radius,
    BoxFit? fit}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius ?? 10),
    child: CachedNetworkImage(
      height: h,
      width: w,
      imageUrl: url,
      fit: fit ?? BoxFit.cover,
      placeholder: (context, url) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.withOpacity(0.5),
          child: Container(
            height: h,
            width: w,
            color: Colors.grey,
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          width: w,
          color: greyLightColor,
          child: Center(
            child: 'No Image!'.semiBoldBarlowTextStyle(),
          ),
        );
      },
    ),
  );
}
```

### networkImage Widget (Basic network image)
```dart
Widget networkImage(String image,
    {double? height, double? width, Color? color, double? scale}) {
  return Image.network(
    image,
    height: height,
    width: width,
    color: color,
  );
}
```

---

## 2. **NC Details Screen** - `nc_details_screen.dart`

**File:** `lib/View/Screen/BottomBarScreen/Dashboard/nc_details_screen.dart`

**Active Image Display (Line 684-688):**
```dart
child: networkImageShimmer(
    h: h * 0.33,
    radius: 0,
    w: w,
    url: controller.projectImage),
```

**API Response Field:** `controller.projectImage`
**Widget Type:** `networkImageShimmer` (CachedNetworkImage with shimmer)
**Purpose:** Display NC (Non-Conformance) project header image

---

## 3. **Project Details Screen** - `project_details_screen.dart`

**File:** `lib/View/Screen/ProjectScreen/Details/project_details_screen.dart`

**Active Image Display (Line 446-451):**
```dart
child: networkImageShimmer(
    h: h * 0.33,
    radius: 0,
    w: w,
    url: cName == "Home Inspection"
        ? controller.hqiImageUrl
        : controller.towerDataRes?.projectData?.imageUrl ?? "",
),
```

**API Response Fields:**
- `controller.hqiImageUrl` (for Home Inspection projects)
- `controller.towerDataRes?.projectData?.imageUrl` (for other projects)

**Widget Type:** `networkImageShimmer`
**Purpose:** Display project header image with conditional URL selection

---

## 4. **Project Checklist Screen** - `project_checklist_screen.dart`

**File:** `lib/View/Screen/ProjectScreen/Checklist/project_checklist_screen.dart`

### Location 1 - Main Project Image (Line 78-82)
```dart
child: networkImageShimmer(
  h: h * 0.25,
  w: w,
  url: "${controller.projectDetailsRes?.projectData?.imageUrl}".toString(),
),
```

**API Response Field:** `controller.projectDetailsRes?.projectData?.imageUrl`
**Widget Type:** `networkImageShimmer`

### Location 2 - Checklist Items (Line 178-184)
```dart
child: networkImageShimmer(
  radius: 10,
  fit: BoxFit.cover,
  h: h * 0.25,
  w: w,
  url: "${controller.projectDetailsRes?.projectData?.checklistData?[index].image}"
      .toString(),
),
```

**API Response Field:** `controller.projectDetailsRes?.projectData?.checklistData?[index].image`
**Widget Type:** `networkImageShimmer`
**Purpose:** Display individual checklist item images

### Location 3 - Conditional URL Processing (Line 242-251)
```dart
child: (controller.projectDetailsRes?.projectData?.imageUrl?.contains('http://') ?? false)
    ? networkImageShimmer(
        h: h * 0.25,
        w: w,
        url: "${controller.projectDetailsRes?.projectData?.imageUrl}".toString(),
      )
    : Image.memory(
        base64Decode(
            "${controller.projectDetailsRes?.projectData?.imageUrl}".toString()),
      ),
```

**URL Processing:** Checks if URL contains `http://` for network images, otherwise decodes as base64
**Widget Types:** `networkImageShimmer` (network) or `Image.memory` (base64)

### Location 4 - Checklist Conditional (Line 351-360)
```dart
child: (controller.projectDetailsRes?.projectData?.checklistData?[index].image?.contains('http://') ?? false)
    ? networkImageShimmer(
        radius: 10,
        fit: BoxFit.cover,
        h: h * 0.25,
        w: w,
        url: "${controller.projectDetailsRes?.projectData?.checklistData?[index].image}".toString(),
      )
    : Image.memory(base64Decode(
        "${controller.projectDetailsRes?.projectData?.checklistData?[index].image}")),
```

**URL Processing:** Conditional check for network vs base64 encoded images

---

## 5. **Material Inspection Screens**

### 5a. Update MI Screen - `update_mi_screen.dart`

**File:** `lib/View/Screen/MaterialInspectionScreen/update_mi_screen.dart`

#### Location 1 - Dialog Image Display (Line 1053-1057)
```dart
image: DecorationImage(
  image: isNetwork == true
      ? NetworkImage("${image}")
      : FileImage(File(image)) as ImageProvider,
  fit: BoxFit.fill,
),
```

**Widget Type:** `NetworkImage` (in DecorationImage)
**Condition:** `isNetwork == true`
**Purpose:** Display enlarged image in dialog with network/file conditional

#### Location 2 - Report Images (Line 1116-1121)
```dart
image: controller.selectedReport?.imageUrlData![index1].contains('http://') ?? false
    ? NetworkImage(controller.selectedReport?.imageUrlData![index1] ?? '')
    : FileImage(File(controller.selectedReport?.imageUrlData?[index1] ?? "")) as ImageProvider,
```

**API Response Field:** `controller.selectedReport?.imageUrlData![index1]`
**Widget Type:** `NetworkImage` (in DecorationImage)
**URL Processing:** Checks if URL contains `http://`

#### Location 3 - Selected Report Images (Line 1166-1172)
```dart
image: controller.selectedReport?.imageUrlData?[index1].contains('http://') ?? false
    ? NetworkImage(controller.selectedReport?.imageUrlData?[index1] ?? '')
    : FileImage(File(controller.selectedReport?.imageUrlData?[index1] ?? "")) as ImageProvider,
```

**API Response Field:** `controller.selectedReport?.imageUrlData?[index1]`
**Widget Type:** `NetworkImage`
**Purpose:** Display selected report images with conditional URL handling

---

### 5b. Create MI Screen - `create_mi_screen.dart`

**File:** `lib/View/Screen/MaterialInspectionScreen/create_mi_screen.dart`

**Active Image Display (Line 1364-1368):**
```dart
image: DecorationImage(
  image: isNetwork == true
      ? NetworkImage(image)
      : FileImage(File(image)) as ImageProvider,
  fit: BoxFit.fill,
),
```

**Widget Type:** `NetworkImage` (in DecorationImage)
**Condition:** `isNetwork == true`
**Purpose:** Display image in dialog with network/file conditional

---

## 6. **Attachment Screen** - `attachment_screen.dart`

**File:** `lib/View/Screen/HomeInscpection/attachment_screen.dart`

### Location 1 - Main Display (Line 830-835)
```dart
decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  image: DecorationImage(
    fit: BoxFit.cover,
    image: getImageProvider(url),
  ),
),
```

### Location 2 - Dialog Display (Line 859-864)
```dart
decoration: BoxDecoration(
  border: Border.all(color: blackColor, width: 1.2),
  borderRadius: BorderRadius.circular(15),
  image: DecorationImage(
    fit: BoxFit.cover,
    image: getImageProvider(url),
  ),
),
```

### Helper Method - getImageProvider (Line 1345-1360)
```dart
ImageProvider getImageProvider(String url) {
  if (url.startsWith('http://') || url.startsWith('https://')) {
    // Network image
    return NetworkImage(url);
  } else if (url.startsWith('/')) {
    // Local file
    final file = File(url);
    if (file.existsSync()) {
      return FileImage(file);
    } else {
      // fallback placeholder
      return const AssetImage('assets/images/placeholder.png');
    }
  } else {
    // Assume base64
    try {
      // ... base64 handling
    }
  }
}
```

**Widget Type:** `NetworkImage` (via getImageProvider helper)
**URL Processing:** Comprehensive handling for:
- HTTP/HTTPS URLs → `NetworkImage`
- Local file paths (starting with `/`) → `FileImage`
- Base64 strings → `MemoryImage`
- Fallback → Asset image placeholder

---

## 7. **Activity History Screen** - `history_screen.dart`

**File:** `lib/View/Screen/ActivityScreen/EditActivity/history_screen.dart`

### Location 1 - Thumbnail Display (Line 136-138)
```dart
image: DecorationImage(
    image: NetworkImage(controller.history[index].imageList[index1]),
    fit: BoxFit.fill),
```

### Location 2 - Dialog Display (Line 165-167)
```dart
image: DecorationImage(
    image: NetworkImage(controller.history[index].imageList[index1]),
    fit: BoxFit.fill),
```

**API Response Field:** `controller.history[index].imageList[index1]`
**Widget Type:** `NetworkImage` (in DecorationImage)
**Purpose:** Display activity images both in list and enlarged dialog

---

## 8. **Offline Data Display Screen** - `show_offline_data_screen.dart`

**File:** `lib/View/Screen/SavedActivityScren/show_offline_data_screen.dart`

**Active Image Display (Line 118-125):**
```dart
child: networkImageShimmer(
  radius: 10,
  fit: BoxFit.cover,
  h: h * 0.25,
  w: w,
  url: index == 0
      ? "http://157.245.102.113:8079/web/image?model=project.details&field=image&id=99".toString()
      : "http://157.245.102.113:8079/web/image?model=project.details&field=image&id=122".toString(),
),
```

**Widget Type:** `networkImageShimmer`
**URL Type:** Hardcoded/static URLs for offline data display
**Purpose:** Display sample project images for offline data

---

## Summary Table

| Screen | File | API Field | Widget Type | URL Processing |
|--------|------|-----------|-------------|-----------------|
| NC Details | `nc_details_screen.dart` | `controller.projectImage` | `networkImageShimmer` | Direct |
| Project Details | `project_details_screen.dart` | `controller.hqiImageUrl` / `towerDataRes?.projectData?.imageUrl` | `networkImageShimmer` | Conditional (HQI vs Tower) |
| Project Checklist | `project_checklist_screen.dart` | `projectDetailsRes?.projectData?.imageUrl` / `checklistData?[index].image` | `networkImageShimmer` / `Image.memory` | URL check (`http://`) |
| Update MI | `update_mi_screen.dart` | `selectedReport?.imageUrlData?[index]` | `NetworkImage` | URL check (`http://`) |
| Create MI | `create_mi_screen.dart` | Image parameter | `NetworkImage` | `isNetwork` flag |
| Attachment | `attachment_screen.dart` | URL variable | `NetworkImage` | `getImageProvider()` helper |
| History | `history_screen.dart` | `history[index].imageList[index1]` | `NetworkImage` | Direct |
| Offline Data | `show_offline_data_screen.dart` | Static URLs | `networkImageShimmer` | Direct |

---

## Key Observations

1. **Primary Image Widget:** `networkImageShimmer` (uses `CachedNetworkImage` with shimmer loading)
2. **Secondary Method:** `NetworkImage` (used in `DecorationImage` containers)
3. **URL Processing Patterns:**
   - Direct string URLs
   - Conditional checks for `http://` prefix
   - Base64 decoding for encoded images
   - File system paths with fallback handling
4. **Response Models Used:**
   - `ProjectDetailsResponse` - for project images
   - `SelectedReport` - for material inspection images
   - `History` model - for activity images
   - Direct controller properties for specific types
