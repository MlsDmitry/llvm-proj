; ModuleID = './example1.c'
source_filename = "./example1.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx12.0.0"

@key = constant [3 x i8] c"\01\02\03", align 1
@.str = private unnamed_addr constant [12 x i8] c"%d Meow...\0A\00", align 1
@.str.1 = private unnamed_addr constant [29 x i8] c"[do_nothing] made something\0A\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.3 = private unnamed_addr constant [27 x i8] c"[do_nothing] made nothing\0A\00", align 1
@.str.4 = private unnamed_addr constant [3 x i8] c"0\0A\00", align 1
@.str.5 = private unnamed_addr constant [3 x i8] c"1\0A\00", align 1
@.str.6 = private unnamed_addr constant [3 x i8] c"2\0A\00", align 1
@.str.7 = private unnamed_addr constant [3 x i8] c"3\0A\00", align 1
@.str.8 = private unnamed_addr constant [3 x i8] c"4\0A\00", align 1
@.str.9 = private unnamed_addr constant [3 x i8] c"5\0A\00", align 1
@.str.10 = private unnamed_addr constant [3 x i8] c"6\0A\00", align 1
@.str.11 = private unnamed_addr constant [3 x i8] c"7\0A\00", align 1
@.str.12 = private unnamed_addr constant [3 x i8] c"8\0A\00", align 1
@.str.13 = private unnamed_addr constant [3 x i8] c"9\0A\00", align 1
@.str.14 = private unnamed_addr constant [4 x i8] c"10\0A\00", align 1
@.str.15 = private unnamed_addr constant [9 x i8] c"default\0A\00", align 1

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
  %4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i64 0, i64 0), i32 %3)
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
  br i1 %10, label %11, label %19

11:                                               ; preds = %1
  %12 = call i8* @encode_alloc(i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.1, i64 0, i64 0), i64 29, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @key, i64 0, i64 0), i64 3)
  store i8* %12, i8** %3, align 8
  %13 = load i8*, i8** %3, align 8
  %14 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i64 0, i64 0), i8* %13)
  %15 = load i8*, i8** %3, align 8
  %16 = call i8* @encode_alloc(i8* %15, i64 29, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @key, i64 0, i64 0), i64 3)
  store i8* %16, i8** %4, align 8
  %17 = load i8*, i8** %4, align 8
  %18 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i64 0, i64 0), i8* %17)
  br label %21

19:                                               ; preds = %1
  %20 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.3, i64 0, i64 0))
  br label %21

21:                                               ; preds = %19, %11
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

7:                                                ; preds = %45, %2
  %8 = load i32, i32* %6, align 4
  %9 = icmp slt i32 %8, 100
  br i1 %9, label %10, label %48

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
  %19 = load i32, i32* %6, align 4
  switch i32 %19, label %42 [
    i32 0, label %20
    i32 1, label %22
    i32 2, label %24
    i32 3, label %26
    i32 4, label %28
    i32 5, label %30
    i32 6, label %32
    i32 7, label %34
    i32 8, label %36
    i32 9, label %38
    i32 10, label %40
  ]

20:                                               ; preds = %18
  %21 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i64 0, i64 0))
  br label %44

22:                                               ; preds = %18
  %23 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.5, i64 0, i64 0))
  br label %44

24:                                               ; preds = %18
  %25 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.6, i64 0, i64 0))
  br label %44

26:                                               ; preds = %18
  %27 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.7, i64 0, i64 0))
  br label %44

28:                                               ; preds = %18
  %29 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.8, i64 0, i64 0))
  br label %44

30:                                               ; preds = %18
  %31 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.9, i64 0, i64 0))
  br label %44

32:                                               ; preds = %18
  %33 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.10, i64 0, i64 0))
  br label %44

34:                                               ; preds = %18
  %35 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i64 0, i64 0))
  br label %44

36:                                               ; preds = %18
  %37 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.12, i64 0, i64 0))
  br label %44

38:                                               ; preds = %18
  %39 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.13, i64 0, i64 0))
  br label %44

40:                                               ; preds = %18
  %41 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.14, i64 0, i64 0))
  br label %44

42:                                               ; preds = %18
  %43 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.15, i64 0, i64 0))
  br label %44

44:                                               ; preds = %42, %40, %38, %36, %34, %32, %30, %28, %26, %24, %22, %20
  br label %45

45:                                               ; preds = %44
  %46 = load i32, i32* %6, align 4
  %47 = add nsw i32 %46, 1
  store i32 %47, i32* %6, align 4
  br label %7, !llvm.loop !8

48:                                               ; preds = %7
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
!5 = !{!"Apple clang version 13.1.6 (clang-1316.0.21.2.3)"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
