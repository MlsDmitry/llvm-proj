; ModuleID = './examples/example1.c'
source_filename = "./examples/example1.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx12.0.0"

@key = local_unnamed_addr constant [3 x i8] c"\01\02\03", align 1
@.str = private unnamed_addr constant [12 x i8] c"%d Meow...\0A\00", align 1
@str = private unnamed_addr constant [26 x i8] c"[do_nothing] made nothing\00", align 1

; Function Attrs: nofree nounwind ssp uwtable
define noalias i8* @encode_alloc(i8* nocapture readonly %0, i64 %1, i8* nocapture readonly %2, i64 %3) local_unnamed_addr #0 {
  %5 = tail call i8* @malloc(i64 %1) #6
  %6 = icmp eq i64 %1, 0
  br i1 %6, label %27, label %7

7:                                                ; preds = %4
  %8 = and i64 %1, 1
  %9 = icmp eq i64 %1, 1
  br i1 %9, label %12, label %10

10:                                               ; preds = %7
  %11 = and i64 %1, -2
  br label %28

12:                                               ; preds = %51, %7
  %13 = phi i64 [ 0, %7 ], [ %54, %51 ]
  %14 = icmp eq i64 %8, 0
  br i1 %14, label %27, label %15

15:                                               ; preds = %12
  %16 = getelementptr i8, i8* %0, i64 %13
  %17 = load i8, i8* %16, align 1, !tbaa !6
  %18 = icmp eq i8 %17, 0
  br i1 %18, label %24, label %19

19:                                               ; preds = %15
  %20 = urem i64 %13, %3
  %21 = getelementptr i8, i8* %2, i64 %20
  %22 = load i8, i8* %21, align 1, !tbaa !6
  %23 = xor i8 %22, %17
  br label %24

24:                                               ; preds = %19, %15
  %25 = phi i8 [ %23, %19 ], [ 0, %15 ]
  %26 = getelementptr inbounds i8, i8* %5, i64 %13
  store i8 %25, i8* %26, align 1, !tbaa !6
  br label %27

27:                                               ; preds = %24, %12, %4
  ret i8* %5

28:                                               ; preds = %51, %10
  %29 = phi i64 [ 0, %10 ], [ %54, %51 ]
  %30 = phi i64 [ %11, %10 ], [ %55, %51 ]
  %31 = getelementptr i8, i8* %0, i64 %29
  %32 = load i8, i8* %31, align 1, !tbaa !6
  %33 = icmp eq i8 %32, 0
  br i1 %33, label %39, label %34

34:                                               ; preds = %28
  %35 = urem i64 %29, %3
  %36 = getelementptr i8, i8* %2, i64 %35
  %37 = load i8, i8* %36, align 1, !tbaa !6
  %38 = xor i8 %37, %32
  br label %39

39:                                               ; preds = %28, %34
  %40 = phi i8 [ %38, %34 ], [ 0, %28 ]
  %41 = getelementptr inbounds i8, i8* %5, i64 %29
  store i8 %40, i8* %41, align 1, !tbaa !6
  %42 = or i64 %29, 1
  %43 = getelementptr i8, i8* %0, i64 %42
  %44 = load i8, i8* %43, align 1, !tbaa !6
  %45 = icmp eq i8 %44, 0
  br i1 %45, label %51, label %46

46:                                               ; preds = %39
  %47 = urem i64 %42, %3
  %48 = getelementptr i8, i8* %2, i64 %47
  %49 = load i8, i8* %48, align 1, !tbaa !6
  %50 = xor i8 %49, %44
  br label %51

51:                                               ; preds = %46, %39
  %52 = phi i8 [ %50, %46 ], [ 0, %39 ]
  %53 = getelementptr inbounds i8, i8* %5, i64 %42
  store i8 %52, i8* %53, align 1, !tbaa !6
  %54 = add nuw nsw i64 %29, 2
  %55 = add i64 %30, -2
  %56 = icmp eq i64 %55, 0
  br i1 %56, label %12, label %28, !llvm.loop !9
}

; Function Attrs: inaccessiblememonly mustprogress nofree nounwind willreturn allocsize(0)
declare noalias noundef i8* @malloc(i64 noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nounwind ssp uwtable willreturn
define void @encode_free(i8* nocapture %0) local_unnamed_addr #2 {
  tail call void @free(i8* %0)
  ret void
}

; Function Attrs: inaccessiblemem_or_argmemonly mustprogress nounwind willreturn
declare void @free(i8* nocapture noundef) local_unnamed_addr #3

; Function Attrs: nofree nounwind ssp uwtable
define void @say_meow(i32 %0) local_unnamed_addr #0 {
  %2 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i64 0, i64 0), i32 %0)
  ret void
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #4

; Function Attrs: nofree nounwind ssp uwtable
define void @do_nothing(i32 %0) local_unnamed_addr #0 {
  %2 = mul nsw i32 %0, 100
  %3 = sdiv i32 %2, 21
  %4 = shl i32 %3, 5
  %5 = add i32 %4, 1280
  %6 = icmp sgt i32 %5, 300
  br i1 %6, label %7, label %54

7:                                                ; preds = %1
  %8 = tail call dereferenceable_or_null(29) i8* @malloc(i64 29) #7
  store i8 90, i8* %8, align 1, !tbaa !6
  %9 = getelementptr inbounds i8, i8* %8, i64 1
  store i8 102, i8* %9, align 1, !tbaa !6
  %10 = getelementptr inbounds i8, i8* %8, i64 2
  store i8 108, i8* %10, align 1, !tbaa !6
  %11 = getelementptr inbounds i8, i8* %8, i64 3
  store i8 94, i8* %11, align 1, !tbaa !6
  %12 = getelementptr inbounds i8, i8* %8, i64 4
  store i8 108, i8* %12, align 1, !tbaa !6
  %13 = getelementptr inbounds i8, i8* %8, i64 5
  store i8 108, i8* %13, align 1, !tbaa !6
  %14 = getelementptr inbounds i8, i8* %8, i64 6
  store i8 117, i8* %14, align 1, !tbaa !6
  %15 = getelementptr inbounds i8, i8* %8, i64 7
  store i8 106, i8* %15, align 1, !tbaa !6
  %16 = getelementptr inbounds i8, i8* %8, i64 8
  store i8 106, i8* %16, align 1, !tbaa !6
  %17 = getelementptr inbounds i8, i8* %8, i64 9
  store i8 111, i8* %17, align 1, !tbaa !6
  %18 = getelementptr inbounds i8, i8* %8, i64 10
  store i8 101, i8* %18, align 1, !tbaa !6
  %19 = getelementptr inbounds i8, i8* %8, i64 11
  store i8 94, i8* %19, align 1, !tbaa !6
  %20 = getelementptr inbounds i8, i8* %8, i64 12
  store i8 33, i8* %20, align 1, !tbaa !6
  %21 = getelementptr inbounds i8, i8* %8, i64 13
  store i8 111, i8* %21, align 1, !tbaa !6
  %22 = getelementptr inbounds i8, i8* %8, i64 14
  store i8 98, i8* %22, align 1, !tbaa !6
  %23 = getelementptr inbounds i8, i8* %8, i64 15
  store i8 101, i8* %23, align 1, !tbaa !6
  %24 = getelementptr inbounds i8, i8* %8, i64 16
  store i8 103, i8* %24, align 1, !tbaa !6
  %25 = getelementptr inbounds i8, i8* %8, i64 17
  store i8 35, i8* %25, align 1, !tbaa !6
  %26 = getelementptr inbounds i8, i8* %8, i64 18
  store i8 114, i8* %26, align 1, !tbaa !6
  %27 = getelementptr inbounds i8, i8* %8, i64 19
  store i8 109, i8* %27, align 1, !tbaa !6
  %28 = getelementptr inbounds i8, i8* %8, i64 20
  store i8 110, i8* %28, align 1, !tbaa !6
  %29 = getelementptr inbounds i8, i8* %8, i64 21
  store i8 100, i8* %29, align 1, !tbaa !6
  %30 = getelementptr inbounds i8, i8* %8, i64 22
  store i8 118, i8* %30, align 1, !tbaa !6
  %31 = getelementptr inbounds i8, i8* %8, i64 23
  store i8 107, i8* %31, align 1, !tbaa !6
  %32 = getelementptr inbounds i8, i8* %8, i64 24
  store i8 104, i8* %32, align 1, !tbaa !6
  %33 = getelementptr inbounds i8, i8* %8, i64 25
  store i8 108, i8* %33, align 1, !tbaa !6
  %34 = getelementptr inbounds i8, i8* %8, i64 26
  store i8 100, i8* %34, align 1, !tbaa !6
  %35 = getelementptr inbounds i8, i8* %8, i64 27
  store i8 11, i8* %35, align 1, !tbaa !6
  %36 = getelementptr inbounds i8, i8* %8, i64 28
  store i8 0, i8* %36, align 1, !tbaa !6
  %37 = tail call i32 @puts(i8* nonnull dereferenceable(1) %8)
  %38 = tail call dereferenceable_or_null(29) i8* @malloc(i64 29) #7
  br label %39

39:                                               ; preds = %66, %7
  %40 = phi i64 [ 0, %7 ], [ %69, %66 ]
  %41 = getelementptr i8, i8* %8, i64 %40
  %42 = load i8, i8* %41, align 1, !tbaa !6
  %43 = icmp eq i8 %42, 0
  br i1 %43, label %49, label %44

44:                                               ; preds = %39
  %45 = urem i64 %40, 3
  %46 = getelementptr [3 x i8], [3 x i8]* @key, i64 0, i64 %45
  %47 = load i8, i8* %46, align 1, !tbaa !6
  %48 = xor i8 %47, %42
  br label %49

49:                                               ; preds = %44, %39
  %50 = phi i8 [ %48, %44 ], [ 0, %39 ]
  %51 = getelementptr inbounds i8, i8* %38, i64 %40
  store i8 %50, i8* %51, align 1, !tbaa !6
  %52 = or i64 %40, 1
  %53 = icmp eq i64 %52, 29
  br i1 %53, label %54, label %57, !llvm.loop !9

54:                                               ; preds = %49, %1
  %55 = phi i8* [ getelementptr inbounds ([26 x i8], [26 x i8]* @str, i64 0, i64 0), %1 ], [ %38, %49 ]
  %56 = tail call i32 @puts(i8* nonnull dereferenceable(1) %55)
  ret void

57:                                               ; preds = %49
  %58 = getelementptr i8, i8* %8, i64 %52
  %59 = load i8, i8* %58, align 1, !tbaa !6
  %60 = icmp eq i8 %59, 0
  br i1 %60, label %66, label %61

61:                                               ; preds = %57
  %62 = urem i64 %52, 3
  %63 = getelementptr [3 x i8], [3 x i8]* @key, i64 0, i64 %62
  %64 = load i8, i8* %63, align 1, !tbaa !6
  %65 = xor i8 %64, %59
  br label %66

66:                                               ; preds = %61, %57
  %67 = phi i8 [ %65, %61 ], [ 0, %57 ]
  %68 = getelementptr inbounds i8, i8* %38, i64 %52
  store i8 %67, i8* %68, align 1, !tbaa !6
  %69 = add nuw nsw i64 %40, 2
  br label %39
}

; Function Attrs: nofree nounwind ssp uwtable
define i32 @main(i32 %0, i8** nocapture readnone %1) local_unnamed_addr #0 {
  br label %4

3:                                                ; preds = %45
  ret i32 0

4:                                                ; preds = %2, %45
  %5 = phi i32 [ 0, %2 ], [ %46, %45 ]
  %6 = and i32 %5, 1
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %8, label %10

8:                                                ; preds = %4
  %9 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i64 0, i64 0), i32 %5) #8
  br label %45

10:                                               ; preds = %4
  %11 = tail call dereferenceable_or_null(29) i8* @malloc(i64 29) #7
  %12 = bitcast i8* %11 to <16 x i8>*
  store <16 x i8> <i8 90, i8 102, i8 108, i8 94, i8 108, i8 108, i8 117, i8 106, i8 106, i8 111, i8 101, i8 94, i8 33, i8 111, i8 98, i8 101>, <16 x i8>* %12, align 1, !tbaa !6
  %13 = getelementptr inbounds i8, i8* %11, i64 16
  store i8 103, i8* %13, align 1, !tbaa !6
  %14 = getelementptr inbounds i8, i8* %11, i64 17
  store i8 35, i8* %14, align 1, !tbaa !6
  %15 = getelementptr inbounds i8, i8* %11, i64 18
  store i8 114, i8* %15, align 1, !tbaa !6
  %16 = getelementptr inbounds i8, i8* %11, i64 19
  store i8 109, i8* %16, align 1, !tbaa !6
  %17 = getelementptr inbounds i8, i8* %11, i64 20
  store i8 110, i8* %17, align 1, !tbaa !6
  %18 = getelementptr inbounds i8, i8* %11, i64 21
  store i8 100, i8* %18, align 1, !tbaa !6
  %19 = getelementptr inbounds i8, i8* %11, i64 22
  store i8 118, i8* %19, align 1, !tbaa !6
  %20 = getelementptr inbounds i8, i8* %11, i64 23
  store i8 107, i8* %20, align 1, !tbaa !6
  %21 = getelementptr inbounds i8, i8* %11, i64 24
  store i8 104, i8* %21, align 1, !tbaa !6
  %22 = getelementptr inbounds i8, i8* %11, i64 25
  store i8 108, i8* %22, align 1, !tbaa !6
  %23 = getelementptr inbounds i8, i8* %11, i64 26
  store i8 100, i8* %23, align 1, !tbaa !6
  %24 = getelementptr inbounds i8, i8* %11, i64 27
  store i8 11, i8* %24, align 1, !tbaa !6
  %25 = getelementptr inbounds i8, i8* %11, i64 28
  store i8 0, i8* %25, align 1, !tbaa !6
  %26 = tail call i32 @puts(i8* nonnull dereferenceable(1) %11) #8
  %27 = tail call dereferenceable_or_null(29) i8* @malloc(i64 29) #7
  br label %28

28:                                               ; preds = %57, %10
  %29 = phi i64 [ 0, %10 ], [ %60, %57 ]
  %30 = getelementptr i8, i8* %11, i64 %29
  %31 = load i8, i8* %30, align 1, !tbaa !6
  %32 = icmp eq i8 %31, 0
  br i1 %32, label %38, label %33

33:                                               ; preds = %28
  %34 = urem i64 %29, 3
  %35 = getelementptr [3 x i8], [3 x i8]* @key, i64 0, i64 %34
  %36 = load i8, i8* %35, align 1, !tbaa !6
  %37 = xor i8 %36, %31
  br label %38

38:                                               ; preds = %33, %28
  %39 = phi i8 [ %37, %33 ], [ 0, %28 ]
  %40 = getelementptr inbounds i8, i8* %27, i64 %29
  store i8 %39, i8* %40, align 1, !tbaa !6
  %41 = or i64 %29, 1
  %42 = icmp eq i64 %41, 29
  br i1 %42, label %43, label %48, !llvm.loop !9

43:                                               ; preds = %38
  %44 = tail call i32 @puts(i8* nonnull dereferenceable(1) %27) #8
  br label %45

45:                                               ; preds = %8, %43
  %46 = add nuw nsw i32 %5, 1
  %47 = icmp eq i32 %46, 100
  br i1 %47, label %3, label %4, !llvm.loop !11

48:                                               ; preds = %38
  %49 = getelementptr i8, i8* %11, i64 %41
  %50 = load i8, i8* %49, align 1, !tbaa !6
  %51 = icmp eq i8 %50, 0
  br i1 %51, label %57, label %52

52:                                               ; preds = %48
  %53 = urem i64 %41, 3
  %54 = getelementptr [3 x i8], [3 x i8]* @key, i64 0, i64 %53
  %55 = load i8, i8* %54, align 1, !tbaa !6
  %56 = xor i8 %55, %50
  br label %57

57:                                               ; preds = %52, %48
  %58 = phi i8 [ %56, %52 ], [ 0, %48 ]
  %59 = getelementptr inbounds i8, i8* %27, i64 %41
  store i8 %58, i8* %59, align 1, !tbaa !6
  %60 = add nuw nsw i64 %29, 2
  br label %28
}

; Function Attrs: nofree nounwind
declare noundef i32 @puts(i8* nocapture noundef readonly) local_unnamed_addr #5

attributes #0 = { nofree nounwind ssp uwtable "darwin-stkchk-strong-link" "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "probe-stack"="___chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }
attributes #1 = { inaccessiblememonly mustprogress nofree nounwind willreturn allocsize(0) "darwin-stkchk-strong-link" "frame-pointer"="all" "no-trapping-math"="true" "probe-stack"="___chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }
attributes #2 = { mustprogress nounwind ssp uwtable willreturn "darwin-stkchk-strong-link" "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "probe-stack"="___chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }
attributes #3 = { inaccessiblemem_or_argmemonly mustprogress nounwind willreturn "darwin-stkchk-strong-link" "frame-pointer"="all" "no-trapping-math"="true" "probe-stack"="___chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }
attributes #4 = { nofree nounwind "darwin-stkchk-strong-link" "frame-pointer"="all" "no-trapping-math"="true" "probe-stack"="___chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }
attributes #5 = { nofree nounwind }
attributes #6 = { allocsize(0) }
attributes #7 = { nounwind allocsize(0) }
attributes #8 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 12, i32 3]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Apple clang version 13.1.6 (clang-1316.0.21.2)"}
!6 = !{!7, !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = distinct !{!9, !10}
!10 = !{!"llvm.loop.mustprogress"}
!11 = distinct !{!11, !10}
