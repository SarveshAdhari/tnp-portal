import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tnp_portal/providers/job_provider.dart';
import 'package:tnp_portal/providers/user_provider.dart';
import 'package:tnp_portal/models/all_jobs.dart';
import 'package:tnp_portal/widgets/admin/admin_job_list.dart';
import 'package:tnp_portal/widgets/all_jobs_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() {
    return _HomepageState();
  }
}

//After login its not working... user must click on homepage from navigation to get data
class _HomepageState extends ConsumerState<Homepage> {
  List<AllJobs> jobs = [];

  @override
  void initState() {
    super.initState();
    getjobs();
  }

  // final List<AllJobs> _jobs = [
  //   AllJobs(companyName: 'TCS',title: 'SDE 1', desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ultricies lorem sapien, sit amet eleifend diam aliquet at. Praesent condimentum nunc non velit malesuada interdum. Etiam interdum, sapien sollicitudin suscipit pellentesque, augue purus pharetra sapien, sed dignissim magna nisi quis felis. Pellentesque id ex erat. Duis rhoncus ut risus ut egestas. Aliquam eu bibendum sapien. Vestibulum non volutpat sem, sit amet pulvinar nibh. Sed malesuada lorem a lorem semper ullamcorper. Pellentesque tincidunt ligula a accumsan rutrum. Donec ac mauris varius, tristique nunc sit amet, facilisis lacus. Vivamus congue condimentum congue. Sed ut dignissim sapien. Fusce finibus nisi tincidunt, tincidunt nunc efficitur, suscipit sapien. Cras a euismod quam.Maecenas sollicitudin blandit diam et scelerisque. Sed condimentum tristique felis eget tempus. Suspendisse quis elementum enim. Praesent viverra eu risus eget pellentesque. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nunc quis est lectus. Praesent eu tellus tortor.Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Aenean eu condimentum tellus. Etiam dignissim massa risus, in porttitor lacus semper ac. Fusce ullamcorper enim at tristique varius. Sed in justo sodales, lacinia lacus convallis, condimentum elit. Nulla non congue dolor. Nunc bibendum venenatis egestas. Duis iaculis egestas lectus quis vulputate. Sed varius lectus quis quam facilisis, ac faucibus enim maximus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc id aliquam lacus. Praesent id nisl sit amet ex luctus convallis.Cras id imperdiet nisi, ac lacinia metus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Fusce egestas, erat at dictum congue, libero sem tempor arcu, sed porttitor felis magna quis eros. Aenean quis nunc nisl. Proin cursus, sapien sit amet convallis gravida, sapien augue faucibus risus, in laoreet lacus turpis non nunc. Nunc arcu diam, accumsan a porttitor in, ullamcorper ac dui. Morbi id nibh mauris. Quisque vitae massa tempor, pellentesque magna vel, pellentesque mauris. Integer aliquet risus et nulla porta, vel dignissim lacus posuere. Maecenas augue ipsum, faucibus a mi id, interdum volutpat turpis. Nunc maximus malesuada porta.Duis risus odio, placerat at commodo porttitor, tempor vitae elit. Aliquam posuere auctor consectetur. Nunc gravida cursus augue. Morbi facilisis quam quis lacinia convallis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Duis feugiat in orci facilisis sagittis. Pellentesque vel odio lobortis, porta orci sed, congue nibh. Proin scelerisque malesuada felis tristique ullamcorper.Lorem, ipsum dolor sit amet consectetur adipisicing elit. Quas quos cumque, ad fugiat pariatur officiis, deleniti quisquam, natus inventore non amet incidunt architecto qui? Fugit vitae provident odit aut, reprehenderit, quis aspernatur illo voluptatem mollitia est iste laboriosam ratione ducimus harum et vel tenetur, ea esse laudantium magni quidem exercitationem!'),
  //   AllJobs(companyName: 'Wipro',title: 'Dev', desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ultricies lorem sapien, sit amet eleifend diam aliquet at. Praesent condimentum nunc non velit malesuada interdum. Etiam interdum, sapien sollicitudin suscipit pellentesque, augue purus pharetra sapien, sed dignissim magna nisi quis felis. Pellentesque id ex erat. Duis rhoncus ut risus ut egestas. Aliquam eu bibendum sapien. Vestibulum non volutpat sem, sit amet pulvinar nibh. Sed malesuada lorem a lorem semper ullamcorper. Pellentesque tincidunt ligula a accumsan rutrum. Donec ac mauris varius, tristique nunc sit amet, facilisis lacus. Vivamus congue condimentum congue. Sed ut dignissim sapien. Fusce finibus nisi tincidunt, tincidunt nunc efficitur, suscipit sapien. Cras a euismod quam.Maecenas sollicitudin blandit diam et scelerisque. Sed condimentum tristique felis eget tempus. Suspendisse quis elementum enim. Praesent viverra eu risus eget pellentesque. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nunc quis est lectus. Praesent eu tellus tortor.Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Aenean eu condimentum tellus. Etiam dignissim massa risus, in porttitor lacus semper ac. Fusce ullamcorper enim at tristique varius. Sed in justo sodales, lacinia lacus convallis, condimentum elit. Nulla non congue dolor. Nunc bibendum venenatis egestas. Duis iaculis egestas lectus quis vulputate. Sed varius lectus quis quam facilisis, ac faucibus enim maximus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc id aliquam lacus. Praesent id nisl sit amet ex luctus convallis.Cras id imperdiet nisi, ac lacinia metus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Fusce egestas, erat at dictum congue, libero sem tempor arcu, sed porttitor felis magna quis eros. Aenean quis nunc nisl. Proin cursus, sapien sit amet convallis gravida, sapien augue faucibus risus, in laoreet lacus turpis non nunc. Nunc arcu diam, accumsan a porttitor in, ullamcorper ac dui. Morbi id nibh mauris. Quisque vitae massa tempor, pellentesque magna vel, pellentesque mauris. Integer aliquet risus et nulla porta, vel dignissim lacus posuere. Maecenas augue ipsum, faucibus a mi id, interdum volutpat turpis. Nunc maximus malesuada porta.Duis risus odio, placerat at commodo porttitor, tempor vitae elit. Aliquam posuere auctor consectetur. Nunc gravida cursus augue. Morbi facilisis quam quis lacinia convallis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Duis feugiat in orci facilisis sagittis. Pellentesque vel odio lobortis, porta orci sed, congue nibh. Proin scelerisque malesuada felis tristique ullamcorper.Lorem, ipsum dolor sit amet consectetur adipisicing elit. Quas quos cumque, ad fugiat pariatur officiis, deleniti quisquam, natus inventore non amet incidunt architecto qui? Fugit vitae provident odit aut, reprehenderit, quis aspernatur illo voluptatem mollitia est iste laboriosam ratione ducimus harum et vel tenetur, ea esse laudantium magni quidem exercitationem!'),
  //   AllJobs(companyName: 'Microsoft',title: 'AI Engineer', desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ultricies lorem sapien, sit amet eleifend diam aliquet at. Praesent condimentum nunc non velit malesuada interdum. Etiam interdum, sapien sollicitudin suscipit pellentesque, augue purus pharetra sapien, sed dignissim magna nisi quis felis. Pellentesque id ex erat. Duis rhoncus ut risus ut egestas. Aliquam eu bibendum sapien. Vestibulum non volutpat sem, sit amet pulvinar nibh. Sed malesuada lorem a lorem semper ullamcorper. Pellentesque tincidunt ligula a accumsan rutrum. Donec ac mauris varius, tristique nunc sit amet, facilisis lacus. Vivamus congue condimentum congue. Sed ut dignissim sapien. Fusce finibus nisi tincidunt, tincidunt nunc efficitur, suscipit sapien. Cras a euismod quam.Maecenas sollicitudin blandit diam et scelerisque. Sed condimentum tristique felis eget tempus. Suspendisse quis elementum enim. Praesent viverra eu risus eget pellentesque. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nunc quis est lectus. Praesent eu tellus tortor.Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Aenean eu condimentum tellus. Etiam dignissim massa risus, in porttitor lacus semper ac. Fusce ullamcorper enim at tristique varius. Sed in justo sodales, lacinia lacus convallis, condimentum elit. Nulla non congue dolor. Nunc bibendum venenatis egestas. Duis iaculis egestas lectus quis vulputate. Sed varius lectus quis quam facilisis, ac faucibus enim maximus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc id aliquam lacus. Praesent id nisl sit amet ex luctus convallis.Cras id imperdiet nisi, ac lacinia metus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Fusce egestas, erat at dictum congue, libero sem tempor arcu, sed porttitor felis magna quis eros. Aenean quis nunc nisl. Proin cursus, sapien sit amet convallis gravida, sapien augue faucibus risus, in laoreet lacus turpis non nunc. Nunc arcu diam, accumsan a porttitor in, ullamcorper ac dui. Morbi id nibh mauris. Quisque vitae massa tempor, pellentesque magna vel, pellentesque mauris. Integer aliquet risus et nulla porta, vel dignissim lacus posuere. Maecenas augue ipsum, faucibus a mi id, interdum volutpat turpis. Nunc maximus malesuada porta.Duis risus odio, placerat at commodo porttitor, tempor vitae elit. Aliquam posuere auctor consectetur. Nunc gravida cursus augue. Morbi facilisis quam quis lacinia convallis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Duis feugiat in orci facilisis sagittis. Pellentesque vel odio lobortis, porta orci sed, congue nibh. Proin scelerisque malesuada felis tristique ullamcorper.Lorem, ipsum dolor sit amet consectetur adipisicing elit. Quas quos cumque, ad fugiat pariatur officiis, deleniti quisquam, natus inventore non amet incidunt architecto qui? Fugit vitae provident odit aut, reprehenderit, quis aspernatur illo voluptatem mollitia est iste laboriosam ratione ducimus harum et vel tenetur, ea esse laudantium magni quidem exercitationem!'),
  //   AllJobs(companyName: 'Google',title: 'DevOps', desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ultricies lorem sapien, sit amet eleifend diam aliquet at. Praesent condimentum nunc non velit malesuada interdum. Etiam interdum, sapien sollicitudin suscipit pellentesque, augue purus pharetra sapien, sed dignissim magna nisi quis felis. Pellentesque id ex erat. Duis rhoncus ut risus ut egestas. Aliquam eu bibendum sapien. Vestibulum non volutpat sem, sit amet pulvinar nibh. Sed malesuada lorem a lorem semper ullamcorper. Pellentesque tincidunt ligula a accumsan rutrum. Donec ac mauris varius, tristique nunc sit amet, facilisis lacus. Vivamus congue condimentum congue. Sed ut dignissim sapien. Fusce finibus nisi tincidunt, tincidunt nunc efficitur, suscipit sapien. Cras a euismod quam.Maecenas sollicitudin blandit diam et scelerisque. Sed condimentum tristique felis eget tempus. Suspendisse quis elementum enim. Praesent viverra eu risus eget pellentesque. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nunc quis est lectus. Praesent eu tellus tortor.Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Aenean eu condimentum tellus. Etiam dignissim massa risus, in porttitor lacus semper ac. Fusce ullamcorper enim at tristique varius. Sed in justo sodales, lacinia lacus convallis, condimentum elit. Nulla non congue dolor. Nunc bibendum venenatis egestas. Duis iaculis egestas lectus quis vulputate. Sed varius lectus quis quam facilisis, ac faucibus enim maximus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc id aliquam lacus. Praesent id nisl sit amet ex luctus convallis.Cras id imperdiet nisi, ac lacinia metus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Fusce egestas, erat at dictum congue, libero sem tempor arcu, sed porttitor felis magna quis eros. Aenean quis nunc nisl. Proin cursus, sapien sit amet convallis gravida, sapien augue faucibus risus, in laoreet lacus turpis non nunc. Nunc arcu diam, accumsan a porttitor in, ullamcorper ac dui. Morbi id nibh mauris. Quisque vitae massa tempor, pellentesque magna vel, pellentesque mauris. Integer aliquet risus et nulla porta, vel dignissim lacus posuere. Maecenas augue ipsum, faucibus a mi id, interdum volutpat turpis. Nunc maximus malesuada porta.Duis risus odio, placerat at commodo porttitor, tempor vitae elit. Aliquam posuere auctor consectetur. Nunc gravida cursus augue. Morbi facilisis quam quis lacinia convallis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Duis feugiat in orci facilisis sagittis. Pellentesque vel odio lobortis, porta orci sed, congue nibh. Proin scelerisque malesuada felis tristique ullamcorper.Lorem, ipsum dolor sit amet consectetur adipisicing elit. Quas quos cumque, ad fugiat pariatur officiis, deleniti quisquam, natus inventore non amet incidunt architecto qui? Fugit vitae provident odit aut, reprehenderit, quis aspernatur illo voluptatem mollitia est iste laboriosam ratione ducimus harum et vel tenetur, ea esse laudantium magni quidem exercitationem!'),
  //   AllJobs(companyName: 'Capgemini',title: 'Associate', desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ultricies lorem sapien, sit amet eleifend diam aliquet at. Praesent condimentum nunc non velit malesuada interdum. Etiam interdum, sapien sollicitudin suscipit pellentesque, augue purus pharetra sapien, sed dignissim magna nisi quis felis. Pellentesque id ex erat. Duis rhoncus ut risus ut egestas. Aliquam eu bibendum sapien. Vestibulum non volutpat sem, sit amet pulvinar nibh. Sed malesuada lorem a lorem semper ullamcorper. Pellentesque tincidunt ligula a accumsan rutrum. Donec ac mauris varius, tristique nunc sit amet, facilisis lacus. Vivamus congue condimentum congue. Sed ut dignissim sapien. Fusce finibus nisi tincidunt, tincidunt nunc efficitur, suscipit sapien. Cras a euismod quam.Maecenas sollicitudin blandit diam et scelerisque. Sed condimentum tristique felis eget tempus. Suspendisse quis elementum enim. Praesent viverra eu risus eget pellentesque. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nunc quis est lectus. Praesent eu tellus tortor.Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Aenean eu condimentum tellus. Etiam dignissim massa risus, in porttitor lacus semper ac. Fusce ullamcorper enim at tristique varius. Sed in justo sodales, lacinia lacus convallis, condimentum elit. Nulla non congue dolor. Nunc bibendum venenatis egestas. Duis iaculis egestas lectus quis vulputate. Sed varius lectus quis quam facilisis, ac faucibus enim maximus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc id aliquam lacus. Praesent id nisl sit amet ex luctus convallis.Cras id imperdiet nisi, ac lacinia metus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Fusce egestas, erat at dictum congue, libero sem tempor arcu, sed porttitor felis magna quis eros. Aenean quis nunc nisl. Proin cursus, sapien sit amet convallis gravida, sapien augue faucibus risus, in laoreet lacus turpis non nunc. Nunc arcu diam, accumsan a porttitor in, ullamcorper ac dui. Morbi id nibh mauris. Quisque vitae massa tempor, pellentesque magna vel, pellentesque mauris. Integer aliquet risus et nulla porta, vel dignissim lacus posuere. Maecenas augue ipsum, faucibus a mi id, interdum volutpat turpis. Nunc maximus malesuada porta.Duis risus odio, placerat at commodo porttitor, tempor vitae elit. Aliquam posuere auctor consectetur. Nunc gravida cursus augue. Morbi facilisis quam quis lacinia convallis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Duis feugiat in orci facilisis sagittis. Pellentesque vel odio lobortis, porta orci sed, congue nibh. Proin scelerisque malesuada felis tristique ullamcorper.Lorem, ipsum dolor sit amet consectetur adipisicing elit. Quas quos cumque, ad fugiat pariatur officiis, deleniti quisquam, natus inventore non amet incidunt architecto qui? Fugit vitae provident odit aut, reprehenderit, quis aspernatur illo voluptatem mollitia est iste laboriosam ratione ducimus harum et vel tenetur, ea esse laudantium magni quidem exercitationem!'),
  //   AllJobs(companyName: 'MasterCard',title: 'Engineer', desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ultricies lorem sapien, sit amet eleifend diam aliquet at. Praesent condimentum nunc non velit malesuada interdum. Etiam interdum, sapien sollicitudin suscipit pellentesque, augue purus pharetra sapien, sed dignissim magna nisi quis felis. Pellentesque id ex erat. Duis rhoncus ut risus ut egestas. Aliquam eu bibendum sapien. Vestibulum non volutpat sem, sit amet pulvinar nibh. Sed malesuada lorem a lorem semper ullamcorper. Pellentesque tincidunt ligula a accumsan rutrum. Donec ac mauris varius, tristique nunc sit amet, facilisis lacus. Vivamus congue condimentum congue. Sed ut dignissim sapien. Fusce finibus nisi tincidunt, tincidunt nunc efficitur, suscipit sapien. Cras a euismod quam.Maecenas sollicitudin blandit diam et scelerisque. Sed condimentum tristique felis eget tempus. Suspendisse quis elementum enim. Praesent viverra eu risus eget pellentesque. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nunc quis est lectus. Praesent eu tellus tortor.Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Aenean eu condimentum tellus. Etiam dignissim massa risus, in porttitor lacus semper ac. Fusce ullamcorper enim at tristique varius. Sed in justo sodales, lacinia lacus convallis, condimentum elit. Nulla non congue dolor. Nunc bibendum venenatis egestas. Duis iaculis egestas lectus quis vulputate. Sed varius lectus quis quam facilisis, ac faucibus enim maximus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc id aliquam lacus. Praesent id nisl sit amet ex luctus convallis.Cras id imperdiet nisi, ac lacinia metus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Fusce egestas, erat at dictum congue, libero sem tempor arcu, sed porttitor felis magna quis eros. Aenean quis nunc nisl. Proin cursus, sapien sit amet convallis gravida, sapien augue faucibus risus, in laoreet lacus turpis non nunc. Nunc arcu diam, accumsan a porttitor in, ullamcorper ac dui. Morbi id nibh mauris. Quisque vitae massa tempor, pellentesque magna vel, pellentesque mauris. Integer aliquet risus et nulla porta, vel dignissim lacus posuere. Maecenas augue ipsum, faucibus a mi id, interdum volutpat turpis. Nunc maximus malesuada porta.Duis risus odio, placerat at commodo porttitor, tempor vitae elit. Aliquam posuere auctor consectetur. Nunc gravida cursus augue. Morbi facilisis quam quis lacinia convallis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Duis feugiat in orci facilisis sagittis. Pellentesque vel odio lobortis, porta orci sed, congue nibh. Proin scelerisque malesuada felis tristique ullamcorper.Lorem, ipsum dolor sit amet consectetur adipisicing elit. Quas quos cumque, ad fugiat pariatur officiis, deleniti quisquam, natus inventore non amet incidunt architecto qui? Fugit vitae provident odit aut, reprehenderit, quis aspernatur illo voluptatem mollitia est iste laboriosam ratione ducimus harum et vel tenetur, ea esse laudantium magni quidem exercitationem!'),
  // ];

  Future<void> getjobs() async {
    List<AllJobs> temp=[];
    final url =
        Uri.https('tnp-portal-2023-default-rtdb.firebaseio.com', 'jobs.json');
    final getResponse = await http.get(url);
    final Map getData = json.decode(getResponse.body);
    for (final x in getData.entries) {
      final cname = x.value['cname'];
      final des = x.value['description'];
      final pos = x.value['position'];
      temp.add(AllJobs(companyName: cname, title: pos, desc: des,applicants: []));
    }
    print(temp);
    setState(() {
      jobs=temp;
    });
  }

  @override
  Widget build(context){
    //Made to set the 
    final user = ref.watch(userProvider);
    // final global_jobs = ref.watch(jobProvider);
    // Here we will set jobs equal to the fetched jobs

    // Fetch All Jobs As A List Here In allJobs (You Can Do It Above As Well, Must Be triggered Everytime The Widget Is Called.)
    // final List<Map<String,String>> fetchedJobs = []; 
    print('jobs in homepage $jobs');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: user['email']=='' ? AdminJobsList(allJobs: jobs):AllJobsList(allJobs: jobs),
    );
    // ListView.builder(itemCount: _jobs.length , itemBuilder: (ctx, index)=> Text(_jobs[index].title));
  }
}