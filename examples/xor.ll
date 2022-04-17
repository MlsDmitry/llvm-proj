; ModuleID = './examples/xor.c'
source_filename = "./examples/xor.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx12.0.0"

@__const.main.key = private unnamed_addr constant [3 x i8] c"\01 4", align 1
@.str = private unnamed_addr constant [53 x i8] c"[do_nothing] made something[do_nothing] made nothing\00", align 1

; Function Attrs: nofree nounwind ssp uwtable
define noalias i8* @encode_alloc(i8* nocapture readonly %0, i64 %1, i8* nocapture readonly %2, i64 %3) local_unnamed_addr #0 {
  %5 = tail call i8* @malloc(i64 %1) #3
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
  %16 = getelementptr inbounds i8, i8* %0, i64 %13
  %17 = load i8, i8* %16, align 1, !tbaa !4
  %18 = icmp eq i8 %17, 0
  br i1 %18, label %24, label %19

19:                                               ; preds = %15
  %20 = urem i64 %13, %3
  %21 = getelementptr inbounds i8, i8* %2, i64 %20
  %22 = load i8, i8* %21, align 1, !tbaa !4
  %23 = xor i8 %22, %17
  br label %24

24:                                               ; preds = %19, %15
  %25 = phi i8 [ %23, %19 ], [ 0, %15 ]
  %26 = getelementptr inbounds i8, i8* %5, i64 %13
  store i8 %25, i8* %26, align 1, !tbaa !4
  br label %27

27:                                               ; preds = %24, %12, %4
  ret i8* %5

28:                                               ; preds = %51, %10
  %29 = phi i64 [ 0, %10 ], [ %54, %51 ]
  %30 = phi i64 [ %11, %10 ], [ %55, %51 ]
  %31 = getelementptr inbounds i8, i8* %0, i64 %29
  %32 = load i8, i8* %31, align 1, !tbaa !4
  %33 = icmp eq i8 %32, 0
  br i1 %33, label %39, label %34

34:                                               ; preds = %28
  %35 = urem i64 %29, %3
  %36 = getelementptr inbounds i8, i8* %2, i64 %35
  %37 = load i8, i8* %36, align 1, !tbaa !4
  %38 = xor i8 %37, %32
  br label %39

39:                                               ; preds = %28, %34
  %40 = phi i8 [ %38, %34 ], [ 0, %28 ]
  %41 = getelementptr inbounds i8, i8* %5, i64 %29
  store i8 %40, i8* %41, align 1, !tbaa !4
  %42 = or i64 %29, 1
  %43 = getelementptr inbounds i8, i8* %0, i64 %42
  %44 = load i8, i8* %43, align 1, !tbaa !4
  %45 = icmp eq i8 %44, 0
  br i1 %45, label %51, label %46

46:                                               ; preds = %39
  %47 = urem i64 %42, %3
  %48 = getelementptr inbounds i8, i8* %2, i64 %47
  %49 = load i8, i8* %48, align 1, !tbaa !4
  %50 = xor i8 %49, %44
  br label %51

51:                                               ; preds = %46, %39
  %52 = phi i8 [ %50, %46 ], [ 0, %39 ]
  %53 = getelementptr inbounds i8, i8* %5, i64 %42
  store i8 %52, i8* %53, align 1, !tbaa !4
  %54 = add nuw nsw i64 %29, 2
  %55 = add i64 %30, -2
  %56 = icmp eq i64 %55, 0
  br i1 %56, label %12, label %28, !llvm.loop !7
}

; Function Attrs: nofree nounwind willreturn allocsize(0)
declare noalias noundef i8* @malloc(i64) local_unnamed_addr #1

; Function Attrs: nofree nounwind ssp uwtable
define i32 @main() local_unnamed_addr #0 {
  %1 = tail call dereferenceable_or_null(52) i8* @malloc(i64 52) #4
  br label %2

2:                                                ; preds = %2, %0
  %3 = phi i64 [ 0, %0 ], [ %19, %2 ]
  %4 = getelementptr inbounds [53 x i8], [53 x i8]* @.str, i64 0, i64 %3
  %5 = load i8, i8* %4, align 1, !tbaa !4
  %6 = urem i64 %3, 3
  %7 = getelementptr inbounds [3 x i8], [3 x i8]* @__const.main.key, i64 0, i64 %6
  %8 = load i8, i8* %7, align 1, !tbaa !4
  %9 = xor i8 %8, %5
  %10 = getelementptr inbounds i8, i8* %1, i64 %3
  store i8 %9, i8* %10, align 1, !tbaa !4
  %11 = or i64 %3, 1
  %12 = getelementptr inbounds [53 x i8], [53 x i8]* @.str, i64 0, i64 %11
  %13 = load i8, i8* %12, align 1, !tbaa !4
  %14 = urem i64 %11, 3
  %15 = getelementptr inbounds [3 x i8], [3 x i8]* @__const.main.key, i64 0, i64 %14
  %16 = load i8, i8* %15, align 1, !tbaa !4
  %17 = xor i8 %16, %13
  %18 = getelementptr inbounds i8, i8* %1, i64 %11
  store i8 %17, i8* %18, align 1, !tbaa !4
  %19 = add nuw nsw i64 %3, 2
  %20 = icmp eq i64 %19, 52
  br i1 %20, label %21, label %2, !llvm.loop !7

21:                                               ; preds = %2
  %22 = tail call i32 @puts(i8* nonnull dereferenceable(1) %1)
  ret i32 0
}

; Function Attrs: nofree nounwind
declare noundef i32 @puts(i8* nocapture noundef readonly) local_unnamed_addr #2

attributes #0 = { nofree nounwind ssp uwtable "darwin-stkchk-strong-link" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "probe-stack"="___chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nounwind willreturn allocsize(0) "darwin-stkchk-strong-link" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "probe-stack"="___chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nofree nounwind }
attributes #3 = { allocsize(0) }
attributes #4 = { nounwind allocsize(0) }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 12, i32 1]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{!"Apple clang version 13.0.0 (clang-1300.0.29.30)"}
!4 = !{!5, !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = distinct !{!7, !8}
!8 = !{!"llvm.loop.mustprogress"}
