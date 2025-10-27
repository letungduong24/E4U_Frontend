# Schedule Feature

Tính năng quản lý thời khóa biểu cho ứng dụng E4U Flutter.

## Cấu trúc thư mục

```
lib/feature/schedule/
├── presentation/
│   ├── screen/
│   │   ├── student_schedule_screen.dart    # Màn hình xem lịch học cho học sinh
│   │   └── admin_schedule_screen.dart      # Màn hình quản lý lịch học cho admin
│   └── widget/
│       ├── calendar_widget.dart            # Widget lịch
│       ├── class_schedule_list.dart       # Danh sách lịch học cho học sinh
│       ├── admin_schedule_list.dart       # Danh sách lịch học cho admin
│       ├── upcoming_assignments_list.dart  # Danh sách bài tập sắp đến hạn
│       └── schedule_modal.dart             # Modal dialog cho CRUD operations
```

## Tính năng

### Cho học sinh:
- Xem lịch học theo ngày
- Xem danh sách bài tập sắp đến hạn
- Lịch tương tác với khả năng chọn ngày

### Cho admin:
- Xem lịch dạy theo ngày
- Tạo lịch học mới (Create)
- Chỉnh sửa lịch học (Update)
- Xóa lịch học (Delete)
- Xác nhận trước khi xóa

## Cách sử dụng

### Navigation
- Học sinh: Drawer > "Lịch học" → `/student-schedule`
- Admin: Drawer > "Quản lý lịch học" → `/admin-schedule`

### CRUD Operations (Admin)
1. **Tạo lịch học**: Nhấn nút "+" (FloatingActionButton)
2. **Chỉnh sửa**: Nhấn icon bút chì bên cạnh lịch học
3. **Xóa**: Nhấn icon thùng rác bên cạnh lịch học

## Mock Data

Hiện tại sử dụng dữ liệu giả lập. Cần thay thế bằng API calls thực tế:

- `_getMockSchedules()` trong `class_schedule_list.dart`
- `_getMockAssignments()` trong `upcoming_assignments_list.dart`
- `_getMockSchedules()` trong `admin_schedule_list.dart`

## Styling

- Màu chủ đạo: `#3396D3` (xanh dương)
- Border radius: 12px cho containers
- Shadow: `BoxShadow` với opacity 0.1
- Font weight: Bold cho tiêu đề, normal cho nội dung
