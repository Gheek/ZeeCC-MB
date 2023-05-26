<a name="readme-top"></a>


<!-- PROJECT SHIELDS -->
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">

<h3 align="center">ZeeCC/MB</h3>

  <p align="center">
    Modbus/TCP Covert Channel Detection Plugin for Zeek
    <br />
    <a href="https://github.com/gheek/ZeeCC-MB"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/gheek/ZeeCC-MB#getting-started">Getting Started</a>
    ·
    <a href="https://github.com/gheek/ZeeCC-MB#about-the-project">More Info</a>
    ·
    <a href="https://github.com/gheek/ZeeCC-MB/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#covert-channels-in-modbustcp">Covert Channels in Modbus/TCP</a>
      <ul>
         <li><a href="#covert-channel-detection">Covert Channel Detection</a></li>
         <li><a href="##cc1---unit-id-modulation">CC1 - Unit ID Modulation</a></li>
         <li><a href="##cc2---unused-bits">CC2 - Unused Bits</a></li>
      </ul>
    </li>
   <li>
      <a href="#references">References</a>
   </li>
   <li>
      <a href="#getting-started">Getting Started</a>
   </li>
   <li><a href="#installation-usage">Installation & Usage</a>
      <ul>
        <li><a href="#quick-start">Quick start</a></li>
        <li><a href="#detailed-instructions">Detailed Instructions</a></li>
      </ul>
   </li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
    <li><a href="#contributing">Contributing</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

This project contains Zeek scripts enabling the detection of Network Covert Channels in Modbus/TCP.

The research for this project is part of my PhD thesis which will be linked here when published.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Covert Channels in Modbus/TCP
> *A covert channel is an evasion or attack technique that is used to transfer information in a secretive, unauthorized or illicit manner.* [(ICANN)](https://www.icann.org/en/blogs/details/what-is-an-internet-covert-channel-29-8-2016-en)

- for details on (Network-) Covert Channels (and more) have a look at our novel *Generic Taxonomy for Steganography Methods* [[WCM+22]](https://doi.org/10.36227/techrxiv.20215373.v2)

- A comprehensive analysis of Covert Channels on Modbus/TCP can be found in our paper *Assessment of Hidden Channel Attacks: Targetting Modbus/TCP* [[LD20]](https://doi.org/10.1016/j.ifacol.2020.12.258)

### Covert Channel Detection

Currently, this plugin is able to detect two covert channels in Modbus/TCP.
More detectors are under development.

#### *CC1* - Unit ID Modulation
![Modbus Unit ID Covert Channel](img/Modbus-UnitID-github-light#gh-light-mode-only.png)
![Modbus Unit ID Covert Channel](img/Modbus-UnitID-github-dark#gh-dark-mode-only.png)
This covert channel uses the Unit ID field to encode hidden information.
Use [conf.zeek](/conf.zeek) to set up Unit IDs that are legit for your setup in order to avoid false positives.
We published and discussed this covert channel in  [[LD20]](https://doi.org/10.1016/j.ifacol.2020.12.258).

#### *CC2* - Unused Bits
![Modbus Unused Bits Covert Channel](img/Modbus-UnusedBits-github-light#gh-light-mode-only.png)
![Modbus Unused Bits Covert Channel](img/Modbus-UnusedBits-github-light#gh-dark-mode-only.png)
This covert channels makes use of unused bits found in certain Modbus/TCP packets, e.g., in case of ReadCoilResponse packets. 
As Modbus/TCP is byte-oriented, 0-7 bits of the last byte may be zero-filled and leveraged by an adversary to establish a hidden communication channel.
We published and discussed this covert channel in [[LD20]](https://doi.org/10.1016/j.ifacol.2020.12.258).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## References

- [WCM+22] Wendzel, Steffen; Caviglione, Luca; Mazurczyk, Wojciech; Mileva, Aleksandra; Dittmann, Jana; Krätzer, Christian; et al. (2022): A Generic Taxonomy for Steganography Methods. TechRxiv. Preprint. https://doi.org/10.36227/techrxiv.20215373.v2
- [LD20] Kevin Lamshöft, Jana Dittmann, Assessment of Hidden Channel Attacks: Targetting Modbus/TCP, IFAC-PapersOnLine, Volume 53, Issue 2, 2020, Pages 11100-11107, ISSN 2405-8963, https://doi.org/10.1016/j.ifacol.2020.12.258.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

Fortunately, Zeek is quite easy to use. The same holds true for any plugins.
Just follow these simple steps:

### Prerequisites
As you probably already guessed it - you need [Zeek](https://zeek.org) installed before using this plugin.

Here's a short primer on Zeek, taken from the [original repo](https://github.com/zeek/zeek).
Of course, fell free to ignore this and just use any package manager you fancy. 

* Zeek
  ```sh
  git clone --recursive https://github.com/zeek/zeek
  ./configure && make && sudo make install
  ```
* CISA Modbus Parser <br>
With Zeek being properly installed, you are basically done with the prerequisites, but - I *highly* recommend to use the awesome CISA ICSNPP Modbus parser to get more detailed logs.
For installation of the parser please head over to the [CISA ICS-NPP Modbus Repo](https://github.com/cisagov/icsnpp-modbus).

That's all, happy times!
With Zeek running properly you can now proceed with the installation of the acutal detection scripts.

### Installation & Usage

#### Quick start

1. Clone the repo:
   ```sh
   git clone https://github.com/gheek/ZeeCC-MB.git
   ```

2. Run & Test the plugin with the provided pcaps, for example:
    ```sh
    zeek -Cr test/unused_bits_sample.pcap zeek-modbus-cc
    ```
   Check the `/test` directory for more examples.

   
3. Detection results are written to `notice.log`:
   ```
   cat notice.log
   ```
#### Detailed Instructions

1. Clone the repo
   ```sh
   git clone https://github.com/gheek/ZeeCC-MB.git
   ```


2. To install this script manually, clone this repository and copy the contents of the scripts directory into `${ZEEK_INSTALLATION_DIR}/share/zeek/site/icsnpp-modbus`.
    ```sh
    git clone https://github.com/gheek/ZeeCC-MB.git
    zeek_install_dir=$(dirname $(dirname `which zeek`))
    cp -r zeek-modbus-cc $zeek_install_dir/share/zeek/site/zeek-modbus-cc
    ```
   
3. If you are using a site deployment, simply add echo `@load zeek-modbus-cc` to your local.site file.


4. If you are not using site/local.zeek or another site installation of Zeek and just want to run this package on a packet capture you can add `zeek-modbus-cc` to your command to run this plugin's scripts on the packet capture:
    ```sh
    zeek -Cr test/unused_bits_sample.pcap zeek-modbus-cc
    ```
   
<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ROADMAP -->
## Roadmap

- [ ] Make plugin compatible for zkg package manager
  - [x] create zkg.meta
- [ ] Implement more covert channels
- [ ] Implement more ICS/OT protocols
- [ ] Integrate into my anomaly detection pipline (*under active development*)

See the [open issues](https://github.com/gheek/ZeeCC-MB/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- CONTACT -->
## Contact

Kevin Lamshöft - [LinkedIn](https://linkedin.com/in/lamshoft) - github@gheek.de

Project Link: [https://github.com/gheek/ZeeCC-MB](https://github.com/gheek/ZeeCC-MB)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* [Zeek](https://zeek.org)
* [CISA Industrial Control Systems Network Protocol Parsers (ICSNPP)](https://github.com/cisagov/ICSNPP)
* [Readme Template](https://github.com/othneildrew/Best-README-Template)
<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are greatly appreciated.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/gheek/ZeeCC-MB.svg?style=for-the-badge
[contributors-url]: https://github.com/gheek/ZeeCC-MB/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/gheek/ZeeCC-MB.svg?style=for-the-badge
[forks-url]: https://github.com/gheek/ZeeCC-MB/network/members
[stars-shield]: https://img.shields.io/github/stars/gheek/ZeeCC-MB.svg?style=for-the-badge
[stars-url]: https://github.com/gheek/ZeeCC-MB/stargazers
[issues-shield]: https://img.shields.io/github/issues/gheek/ZeeCC-MB.svg?style=for-the-badge
[issues-url]: https://github.com/gheek/ZeeCC-MB/issues
[license-shield]: https://img.shields.io/github/license/gheek/ZeeCC-MB.svg?style=for-the-badge
[license-url]: https://github.com/gheek/ZeeCC-MB/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/lamshoft
[product-screenshot]: images/screenshot.png
[Next.js]: https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white
[Next-url]: https://nextjs.org/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://reactjs.org/
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/
[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[Svelte-url]: https://svelte.dev/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com 