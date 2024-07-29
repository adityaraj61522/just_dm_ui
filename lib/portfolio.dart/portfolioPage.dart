import 'dart:math';
import 'package:just_dm_ui/common_widgets/commonWidgets.dart';
import 'package:just_dm_ui/portfolio.dart/portfolioController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PortfolioPage
    extends StatelessWidget {
  PortfolioPage({
    Key? key,
  }) : super(key: key);

  final controller =
      Get.put(LandingPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: buildContent());
  }

  Widget buildContent() {
    return LayoutBuilder(
      builder: (BuildContext context,
          BoxConstraints constraints) {
        if (constraints.maxWidth >
            950) {
          return Container(
            color: Colors.grey.shade900,
            child:
                buildDesktopContent(),
          );
        } else {
          return Container(
            // color: Get
            //     .theme.backgroundColor,
            child: buildMobileContent(),
          );
        }
      },
    );
  }

  Widget buildDesktopContent() {
    return Row(
      children: [
        10.horizontalSpace,
        const CommonDivider(),
        Expanded(
          child: buildLeftPannel(),
        ),
        const CommonDivider(),
        Expanded(
          flex: 3,
          child: buildRightPannel(),
        ),
      ],
    );
  }

  Widget buildLeftPannel() {
    final socialMediaList =
        controller.socialMediaList;
    return Padding(
      padding:
          const EdgeInsets.all(15.0),
      child: LayoutBuilder(
        builder: (BuildContext context,
            BoxConstraints
                constraints) {
          return Padding(
            padding:
                const EdgeInsets.all(
                    20.0),
            child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                mainAxisSize:
                    MainAxisSize.max,
                children: [
                  Texts(
                    text:
                        controller.name,
                    fontSize: 24,
                    bold: true,
                  ),
                  const Spacer(),
                  ImageTextCell(
                    img: controller
                        .profilePhoto,
                    height: constraints
                        .maxWidth,
                    width: constraints
                            .maxHeight /
                        2.5,
                    borderRadius: 20,
                    trimImgBorder: true,
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  Texts(
                    text: controller
                        .designation,
                    fontSize: 18,
                  ),
                  3.verticalSpace,
                  Texts(
                    text: controller
                        .basedIn,
                    fontSize: 14,
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  Center(
                    child: Wrap(
                      spacing: max(
                          (constraints.maxWidth -
                                  180) /
                              4,
                          10),
                      runSpacing: 10,
                      alignment:
                          WrapAlignment
                              .center,
                      children: [
                        ...List
                            .generate(
                          socialMediaList
                              .length,
                          (index) =>
                              ImageTextCell(
                            img: socialMediaList[
                                index],
                            width: 40,
                            height: 40,
                            borderRadius:
                                20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  CommonButton(
                    img: controller
                        .gmailLogo,
                    text: "HIRE ME",
                    height: 50,
                    width: constraints
                        .maxWidth,
                  )
                ]),
          );
        },
      ),
    );
  }

  Widget buildRightPannel() {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.all(50.0),
        child: LayoutBuilder(
          builder:
              (BuildContext context,
                  BoxConstraints
                      constraints) {
            return Padding(
              padding:
                  const EdgeInsets.all(
                      20.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  buildIntroSection(),
                  30.verticalSpace,
                  buildAboutSection(),
                  30.verticalSpace,
                  buildTechnologiesSection(),
                  30.verticalSpace,
                  buildEducationSection(),
                  30.verticalSpace,
                  buildExperienceSection(),
                  30.verticalSpace,
                  buildProjectSection(
                      constraints),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildIntroSection() {
    final introductionList =
        controller.introductionList[0];
    return Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            MainAxisAlignment.start,
        children: [
          ImageTextCell(
            text: "Introduction",
            width: 200,
            height: 50,
            borderRadius: 20,
          ),
          20.verticalSpace,
          Texts(
            text: introductionList[
                "title"]!,
            fontSize: 60,
          ),
          10.verticalSpace,
          Texts(
            text: introductionList[
                "point1"]!,
            fontSize: 14,
            dot: true,
          ),
          10.verticalSpace,
          Texts(
            text: introductionList[
                "point2"]!,
            fontSize: 14,
            dot: true,
          ),
          10.verticalSpace,
          Texts(
            text: introductionList[
                "point3"]!,
            fontSize: 14,
            dot: true,
          ),
          30.verticalSpace,
          CommonButton(
            text: "Contact Me",
            height: 50,
            width: 200,
          ),
        ]);
  }

  Widget buildAboutSection() {
    return Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            MainAxisAlignment.start,
        children: [
          const ImageTextCell(
            text: "About",
            width: 200,
            height: 50,
            borderRadius: 20,
          ),
          20.verticalSpace,
          const Texts(
            text: "About My Self",
            fontSize: 60,
          ),
          3.verticalSpace,
          Texts(
            text: controller.aboutText,
            fontSize: 14,
            maxLine: 5,
          ),
        ]);
  }

  Widget buildTechnologiesSection() {
    final List<String>
        technologyNameList =
        controller.technologyNameList;
    final List<String>
        technologyLinkList =
        controller.technologyLinkList;

    return Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            MainAxisAlignment.start,
        children: [
          const ImageTextCell(
            text: "Technologies",
            width: 200,
            height: 50,
            borderRadius: 20,
          ),
          20.verticalSpace,
          Wrap(
            runSpacing: 40,
            spacing: 40,
            children: [
              ...List.generate(
                technologyNameList
                    .length,
                (index) =>
                    ImageTextCell(
                  img:
                      technologyLinkList[
                          index],
                  text:
                      technologyNameList[
                          index],
                  width: 150,
                  height: 200,
                  imgHeight: 100,
                  imgWidth: 100,
                  spaceBetweenImgAndText:
                      20,
                  fontSize: 20,
                  borderRadius: 20,
                ),
              ),
            ],
          )
        ]);
  }

  Widget buildEducationSection() {
    final buildEduMapList =
        controller.educationList;
    return Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            MainAxisAlignment.start,
        children: [
          const ImageTextCell(
            text: "Education",
            width: 200,
            height: 50,
            borderRadius: 20,
          ),
          20.verticalSpace,
          const Texts(
            text: "Education",
            fontSize: 24,
          ),
          20.verticalSpace,
          ...List.generate(
            buildEduMapList.length,
            (index) => Column(
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .start,
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  mainAxisSize:
                      MainAxisSize.max,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration:
                              BoxDecoration(
                            color: Colors
                                .green,
                            borderRadius:
                                BorderRadius.circular(
                                    50),
                          ),
                        ),
                        const CommonDivider(),
                      ],
                    ),
                    30.horizontalSpace,
                    Expanded(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .start,
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Texts(
                            text: buildEduMapList[
                                    index]
                                [
                                "degree"]!,
                            fontSize:
                                24,
                          ),
                          3.verticalSpace,
                          Texts(
                            text: buildEduMapList[
                                    index]
                                [
                                "collage"]!,
                            fontSize:
                                14,
                          ),
                          3.verticalSpace,
                          Texts(
                            text: buildEduMapList[
                                    index]
                                [
                                "fromTo"]!,
                            fontSize:
                                14,
                          ),
                          3.verticalSpace,
                          Texts(
                            text: buildEduMapList[
                                    index]
                                [
                                "course"]!,
                            fontSize:
                                14,
                          ),
                          20.verticalSpace,
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ]);
  }

  Widget buildExperienceSection() {
    final buildExperienceMapList =
        controller.experienceList;
    return Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            MainAxisAlignment.start,
        children: [
          const ImageTextCell(
            text: "Experience",
            width: 200,
            height: 50,
            borderRadius: 20,
          ),
          20.verticalSpace,
          const Texts(
            text: "Experience",
            fontSize: 24,
          ),
          20.verticalSpace,
          ...List.generate(
            buildExperienceMapList
                .length,
            (index) => Column(
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .start,
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  mainAxisSize:
                      MainAxisSize.max,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration:
                              BoxDecoration(
                            color: Colors
                                .green,
                            borderRadius:
                                BorderRadius.circular(
                                    50),
                          ),
                        ),
                        const CommonDivider(),
                      ],
                    ),
                    30.horizontalSpace,
                    Expanded(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .start,
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Texts(
                            text: buildExperienceMapList[
                                    index]
                                [
                                "profile"]!,
                            fontSize:
                                24,
                          ),
                          3.verticalSpace,
                          Texts(
                            text: buildExperienceMapList[
                                    index]
                                [
                                "company"]!,
                            fontSize:
                                14,
                          ),
                          3.verticalSpace,
                          Texts(
                            text: buildExperienceMapList[
                                    index]
                                [
                                "fromTo"]!,
                            fontSize:
                                14,
                          ),
                          3.verticalSpace,
                          Texts(
                            text: buildExperienceMapList[
                                    index]
                                [
                                "responsibility1"]!,
                            fontSize:
                                14,
                          ),
                          3.verticalSpace,
                          Texts(
                            text: buildExperienceMapList[
                                    index]
                                [
                                "responsibility2"]!,
                            fontSize:
                                14,
                          ),
                          3.verticalSpace,
                          Texts(
                            text: buildExperienceMapList[
                                    index]
                                [
                                "responsibility3"]!,
                            fontSize:
                                14,
                          ),
                          20.verticalSpace,
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ]);
  }

  Widget buildProjectSection(
      constraints) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.start,
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        ImageTextCell(
          text: "Projects",
          width: 200,
          height: 50,
          borderRadius: 20,
        ),
        28.verticalSpace,
        Row(
          mainAxisAlignment:
              MainAxisAlignment.start,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            ImageTextCell(
              text: "Introduction",
              width:
                  constraints.maxWidth /
                      2,
              height: 300,
              borderRadius: 20,
            ),
            20.horizontalSpace,
            Container(
              width:
                  constraints.maxWidth /
                      2.5,
              child: Column(
                children: [
                  const Texts(
                    text:
                        "I love exploring new things!",
                    fontSize: 30,
                    maxLine: 2,
                  ),
                  3.verticalSpace,
                  const Texts(
                    text:
                        "I'm an India based software developer with a goal-driven creative mindset and passion for learning and innovating.",
                    fontSize: 14,
                    maxLine: 2,
                    dot: true,
                  ),
                  3.verticalSpace,
                  const Texts(
                    text:
                        "Currently working as a Software Developer at Amdocs and as a Freelance Content Writer for Pepper Content.",
                    fontSize: 14,
                    maxLine: 3,
                    dot: true,
                  ),
                  3.verticalSpace,
                  const Texts(
                    text:
                        "Outside work, I occasionally blog on Medium. Off-screen, I sketch my thoughts here!",
                    fontSize: 14,
                    maxLine: 2,
                    dot: true,
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Widget buildMobileContent() {
    return Container();
  }
}
