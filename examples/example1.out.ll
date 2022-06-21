; ModuleID = '/Users/kalius/Documents/spbctf/tools/llvm_proj/examples/example1.ll'
source_filename = "./example1.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx12.0.0"

@key = constant [3 x i8] c"\E8\16\9C", align 1
@.str = private unnamed_addr constant [12 x i8] c"\95\A2S\08\D5\A9\04k\9E\E8y\00", align 1
@.str.1 = private unnamed_addr constant [29 x i8] c"\E6\0A\16\0E\D3\01\0D9\D4\00\1E\0C\9D\03\185\D8N\0A>\D0\0B\0D9\D4\00\1E[\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"BCm\00", align 1
@.str.3 = private unnamed_addr constant [27 x i8] c"\D44\CEj\E1?\D5]\E6>\C6h\AF=\C0Q\EAp\CFZ\FB8\C8[\E8Z\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable
define i8* @encode_alloc(i8* %0, i64 %1, i8* %2, i64 %3) #0 {
  %5 = alloca i8*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i64, align 8
  %9 = alloca i8*, align 8
  %10 = alloca i32, align 4
  %11 = alloca i8, align 1
  store i8* %0, i8** %5, align 8
  store i64 %1, i64* %6, align 8
  store i8* %2, i8** %7, align 8
  store i64 %3, i64* %8, align 8
  %12 = load i64, i64* %6, align 8
  %13 = call i8* @malloc(i64 %12) #3
  store i8* %13, i8** %9, align 8
  store i32 0, i32* %10, align 4
  br label %14

14:                                               ; preds = %48, %4
  %15 = load i32, i32* %10, align 4
  %16 = sext i32 %15 to i64
  %17 = load i64, i64* %6, align 8
  %18 = icmp ult i64 %16, %17
  br i1 %18, label %19, label %51

19:                                               ; preds = %14
  %20 = load i8*, i8** %5, align 8
  %21 = load i32, i32* %10, align 4
  %22 = sext i32 %21 to i64
  %23 = getelementptr i8, i8* %20, i64 %22
  %24 = load i8, i8* %23, align 1
  store i8 %24, i8* %11, align 1
  %25 = load i8, i8* %11, align 1
  %26 = zext i8 %25 to i32
  %27 = icmp eq i32 %26, 0
  br i1 %27, label %28, label %29

28:                                               ; preds = %19
  br label %41

29:                                               ; preds = %19
  %30 = load i8, i8* %11, align 1
  %31 = zext i8 %30 to i32
  %32 = load i8*, i8** %7, align 8
  %33 = load i32, i32* %10, align 4
  %34 = sext i32 %33 to i64
  %35 = load i64, i64* %8, align 8
  %36 = urem i64 %34, %35
  %37 = getelementptr i8, i8* %32, i64 %36
  %38 = load i8, i8* %37, align 1
  %39 = zext i8 %38 to i32
  %40 = xor i32 %31, %39
  br label %41

41:                                               ; preds = %29, %28
  %42 = phi i32 [ 0, %28 ], [ %40, %29 ]
  %43 = trunc i32 %42 to i8
  %44 = load i8*, i8** %9, align 8
  %45 = load i32, i32* %10, align 4
  %46 = sext i32 %45 to i64
  %47 = getelementptr inbounds i8, i8* %44, i64 %46
  store i8 %43, i8* %47, align 1
  br label %48

48:                                               ; preds = %41
  %49 = load i32, i32* %10, align 4
  %50 = add nsw i32 %49, 1
  store i32 %50, i32* %10, align 4
  br label %14, !llvm.loop !6

51:                                               ; preds = %14
  %52 = load i8*, i8** %9, align 8
  ret i8* %52
}

; Function Attrs: allocsize(0)
declare i8* @malloc(i64) #1

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @encode_free(i8* %0) #0 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  %3 = load i8*, i8** %2, align 8
  call void @free(i8* %3)
  ret void
}

declare void @free(i8*) #2

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @say_meow(i32 %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = load i32, i32* %2, align 4
  %4 = call i8* @encode_alloc(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i64 0, i64 0), i64 12, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i64 0, i64 0), i64 12)
  %5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i64 0, i64 0), i32 %3)
  ret void
}

declare i32 @printf(i8*, ...) #2

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @do_nothing(i32 %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store i32 %0, i32* %2, align 4
  %5 = load i32, i32* %2, align 4
  %6 = mul nsw i32 %5, 100
  %7 = sdiv i32 %6, 21
  %8 = add nsw i32 %7, 40
  %9 = mul nsw i32 %8, 32
  %10 = icmp sgt i32 %9, 300
  br i1 %10, label %11, label %24

11:                                               ; preds = %1
  %12 = call i8* @encode_alloc(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @key, i64 0, i64 0), i64 3, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @key, i64 0, i64 0), i64 3)
  %13 = call i8* @encode_alloc(i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.1, i64 0, i64 0), i64 29, i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.1, i64 0, i64 0), i64 29)
  %14 = call i8* @encode_alloc(i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.1, i64 0, i64 0), i64 29, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @key, i64 0, i64 0), i64 3)
  store i8* %14, i8** %3, align 8
  %15 = load i8*, i8** %3, align 8
  %16 = call i8* @encode_alloc(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i64 0, i64 0), i64 4, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i64 0, i64 0), i64 4)
  %17 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i64 0, i64 0), i8* %15)
  %18 = load i8*, i8** %3, align 8
  %19 = call i8* @encode_alloc(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @key, i64 0, i64 0), i64 3, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @key, i64 0, i64 0), i64 3)
  %20 = call i8* @encode_alloc(i8* %18, i64 29, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @key, i64 0, i64 0), i64 3)
  store i8* %20, i8** %4, align 8
  %21 = load i8*, i8** %4, align 8
  %22 = call i8* @encode_alloc(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i64 0, i64 0), i64 4, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i64 0, i64 0), i64 4)
  %23 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i64 0, i64 0), i8* %21)
  br label %27

24:                                               ; preds = %1
  %25 = call i8* @encode_alloc(i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.3, i64 0, i64 0), i64 27, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.3, i64 0, i64 0), i64 27)
  %26 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.3, i64 0, i64 0))
  br label %27

27:                                               ; preds = %24, %11
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @main(i32 %0, i8** %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  store i8** %1, i8*** %5, align 8
  store i32 0, i32* %6, align 4
  br label %7

7:                                                ; preds = %19, %2
  %8 = load i32, i32* %6, align 4
  %9 = icmp slt i32 %8, 100
  br i1 %9, label %10, label %22

10:                                               ; preds = %7
  %11 = load i32, i32* %6, align 4
  %12 = srem i32 %11, 2
  %13 = icmp eq i32 %12, 0
  br i1 %13, label %14, label %16

14:                                               ; preds = %10
  %15 = load i32, i32* %6, align 4
  call void @say_meow(i32 %15)
  br label %18

16:                                               ; preds = %10
  %17 = load i32, i32* %6, align 4
  call void @do_nothing(i32 %17)
  br label %18

18:                                               ; preds = %16, %14
  br label %19

19:                                               ; preds = %18
  %20 = load i32, i32* %6, align 4
  %21 = add nsw i32 %20, 1
  store i32 %21, i32* %6, align 4
  br label %7, !llvm.loop !8

22:                                               ; preds = %7
  ret i32 0
}

attributes #0 = { noinline nounwind optnone ssp uwtable "darwin-stkchk-strong-link" "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "probe-stack"="___chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }
attributes #1 = { allocsize(0) "darwin-stkchk-strong-link" "frame-pointer"="all" "no-trapping-math"="true" "probe-stack"="___chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }
attributes #2 = { "darwin-stkchk-strong-link" "frame-pointer"="all" "no-trapping-math"="true" "probe-stack"="___chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }
attributes #3 = { allocsize(0) }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 12, i32 3]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Apple clang version 13.1.6 (clang-1316.0.21.2.5)"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
