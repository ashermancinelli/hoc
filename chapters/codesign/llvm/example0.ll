; ModuleID = 'example'
source_filename = "example"

define i32 @add_ints(i32 %0, i32 %1) {
entry:
  %2 = add i32 %0, %1
  ret i32 %2
}
